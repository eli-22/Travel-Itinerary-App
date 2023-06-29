//
//  AccentButton.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct AccentButton: View {
    
    var buttonName: String
    
    var body: some View {
        Text(buttonName)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 250, height: 45)
            .background(Color("brandSecondary"))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct AccentButton_Previews: PreviewProvider {
    static var previews: some View {
        AccentButton(buttonName: "Preview")
    }
}
