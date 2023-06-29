//
//  NearbyMapPin.swift
//  ItineraryMap
//
//  Created by Elise on 2/17/23.
//

import SwiftUI

// Custom pins for Nearby Places Map.

struct NearbyMapPin: View {
    
    let location: Location
    
    var body: some View {
        Image(systemName: "mappin")
            .font(.title)
            .foregroundColor(Color("brandPrimary"))
    }
}

struct NearbyMapPin_Previews: PreviewProvider {
    static var previews: some View {
        NearbyMapPin(location: MockLocations.topRock)
    }
}
