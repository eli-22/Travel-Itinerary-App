//
//  SavedMapPin.swift
//  ItineraryMap
//
//  Created by Elise on 2/20/23.
//

import SwiftUI

// Custom pins for Saved Places Map.

struct SavedMapPin: View {
    
    let location: Location
    
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.title)
            .foregroundColor(.pink)
    }
}

struct SavedMapPin_Previews: PreviewProvider {
    static var previews: some View {
        SavedMapPin(location: MockLocations.topRock)
    }
}
