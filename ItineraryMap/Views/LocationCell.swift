//
//  LocationCell.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct LocationCell: View {
    var location: Location
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.semibold)
            Text(location.address)
        }.padding()
    }
}

struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(location: MockLocations.topRock)
    }
}
