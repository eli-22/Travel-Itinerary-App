//
//  TripCell.swift
//  ItineraryMap
//
//  Created by Elise on 2/14/23.
//

import SwiftUI

struct TripCell: View {
    
    let trip: TripViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(trip.name)
                .font(.title2)
                .fontWeight(.semibold)
            Text("\(trip.startDate ?? "") - \(trip.endDate ?? "")")
        }.padding()
    }
}
