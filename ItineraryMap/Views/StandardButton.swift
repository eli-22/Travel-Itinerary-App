//
//  StandardButton.swift
//  ItineraryMap
//
//  Created by Elise on 2/16/23.
//

import SwiftUI

struct StandardButton: View {
    
    var buttonName: String
    
    var body: some View {
        Text(buttonName)
            .font(.title2)
            .fontWeight(.medium)
            .frame(width: 250, height: 45)
            .background(Color("brandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(buttonName: "Preview")
    }
}
