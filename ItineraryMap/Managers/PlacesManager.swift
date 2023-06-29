//
//  PlacesManager.swift
//  ItineraryMap
//
//  Created by Elise on 2/8/23.
//

import SwiftUI
import MapKit
import GooglePlaces
import Combine

enum GooglePlacesError: Error {
    case failedToFind
}

class PlacesManager: NSObject, ObservableObject {
    
    // Singleton design pattern
    static let sharedPlacesManager = PlacesManager()
    
    // Google also provides a shared instance.
    private var placesClient = GMSPlacesClient.shared()
    
    // Used in NearbyMapView
    // Publish an array of nearby places
    @Published var nearbyPlaces = [GMSPlaceLikelihood]()
    @Published var nearbyLocations = [Location]()
    
    // Used in PlaceDetailView
    // Publish array of images, which is populated with new photos when getPlacePhotos() is called.
    @Published var imageArray = [UIImage]()
    
    // Used in CreateTripView for autocomplete suggestions.
    @Published var suggestedLocations = [Location]()
    
    // Used in SavedPlacesMapView
    @Published var savedLocations = [Location]()
    
    override init() {
        super.init()
        findNearbyPlaces()
        print("-------Places Manager initialized-------")
    }
    
    func findNearbyPlaces() {
        // likelihoodList is type GMSPlaceLikelihoodList?
        placesClient.currentPlace { likelihoodList, googleError in
            if let googleError {
                print("Failed to find current place: ", googleError)
                return
            }
            
            likelihoodList?.likelihoods.forEach({ likelihood in
                // likelihood is type GMSPlaceLikelihood
                // place is type GMSPlace
                print(likelihood.place.name ?? "")
                
                let place = likelihood.place
                let newLocation = Location(
                    placeID: place.placeID ?? "",
                    name: place.name ?? "Unknown",
                    address: place.formattedAddress ?? "Address not available",
                    coordinate: place.coordinate)
                
                self.nearbyLocations.append(newLocation)
            })
        }
    }
    
    func getPlacePhotos(placeID: String, completion: @escaping () -> Void) {
        // Weak self to avoid potential retain cycle.
        self.placesClient.lookUpPhotos(forPlaceID: placeID) { [weak self] (metadataList, photoError) in
            if photoError != nil {
                print ("App encountered an error looking up photos.")
                print (photoError as Any)
                return
            }
            print("---------PHOTO METADATA-----------")
            print(metadataList as Any)
            
            // Groups allow you to aggregate a set of tasks and synchronize behaviors on the group. You attach multiple work items to a group and schedule them for asynchronous execution on the same queue or different queues. When all work items finish executing, the group executes its completion handler. You can also wait synchronously for all tasks in the group to finish executing.
            
            // Each enter call must have a corresponding leave call.
            
            let dispatchGroup = DispatchGroup()
            var imageArray = [UIImage]()
            
            // Results are type [GMSPlacePhotoMetadata]
            metadataList?.results.forEach( { photoMetadata in
                dispatchGroup.enter()
                self?.placesClient.loadPlacePhoto(photoMetadata) { (image, photoError) in
                    if photoError != nil {
                        print("Failed to load photo.")
                        print (photoError as Any)
                        return
                    }
                    guard image != nil else { return }
                    imageArray.append(image!)
                    dispatchGroup.leave()
                }
            })
            
            // Notify the main queue when for loop has completed and all images are loaded.
            dispatchGroup.notify(queue: .main) {
                self?.imageArray = imageArray
                print(imageArray)
                print("Notify")
            }
        }
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func displaySearchResults(searchQuery: String?) {
        
        // Empty the array to ensure the changes publish and update the view.
        self.suggestedLocations = []
        guard let query = searchQuery,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        self.searchPlaces(query: query) { result in
            switch result {
            case .success(let places):
                print("-----PLACE IDS------")
                print(places)
                self.getSuggestedPlaces(placeIdArray: places)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // Changed [GooglePlace] return type to [String], so I can use place IDs to get corresponding GMSPlaces, which I can then convert to Location type in order to display and add to itinerary.
    // This function seems to work fine, I can print the string array from TripDetailViewModel.
    func searchPlaces(query: String, completion: @escaping (Result<[String], Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        // Can filter by region, geocode, city, establishment, address.
        filter.types = ["geocode"]
        placesClient.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil) { results, error in
                // Optional array of predictions.
                guard let results = results, error == nil else {
                    completion(.failure(GooglePlacesError.failedToFind))
                    return }
                
                // compactMap(_:) returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
                // Transform the array of GMSAutocompletePrediction objects into an array of strings.
                let autocompletePlaceIDs: [String] = results.compactMap({
                    $0.placeID
                })
                
                completion(.success(autocompletePlaceIDs))
            }
    }
    
    func getSuggestedPlaces(placeIdArray: [String]) {
        for place in placeIdArray {
            self.getLocationByID(placeID: place)
        }
    }
    
    func getLocationByID(placeID: String) {
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |  UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) |  UInt(GMSPlaceField.coordinate.rawValue))
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: nil, callback: {
            (gmsPlace: GMSPlace?, error: Error?) in
            
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            
            if let gmsPlace {
                let newLocation = Location(
                    placeID: placeID,
                    name: gmsPlace.name ?? "Unknown",
                    address: gmsPlace.formattedAddress ?? "Address unavailable",
                    coordinate: gmsPlace.coordinate)
                self.suggestedLocations.append(newLocation)
                print("----suggested locations PlacesManager---")
                print(self.suggestedLocations)
            }
        })
    }
}
