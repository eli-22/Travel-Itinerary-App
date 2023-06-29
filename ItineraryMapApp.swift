//
//  ItineraryMapApp.swift
//  ItineraryMap
//
//  Created by Elise on 2/1/23.
//

import SwiftUI
import GooglePlaces

@main
struct ItineraryMapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            let loginViewModel = LoginViewModel()
            WelcomeView()
                .environmentObject(loginViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSPlacesClient.provideAPIKey("")
        /*
         Create API key here:
         https://developers.google.com/maps/documentation/places/ios-sdk/get-api-key#creating-api-keys
         */
        return true
    }
}
 
