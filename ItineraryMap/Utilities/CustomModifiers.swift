//
//  CustomModifiers.swift
//  ItineraryMap
//
//  Created by Elise on 2/18/23.
//

import SwiftUI

struct StandardButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.medium)
            .frame(width: 250, height: 45)
            .background(Color("brandPrimary"))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct AccentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 250, height: 45)
            .background(Color("brandSecondary"))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// Another option: Just type .StandardButtonStyle() instead of .modifier(StandardButtonStyle())
extension View {
    func standardButtonStyle() -> some View {
        self.modifier(StandardButtonStyle())
    }
}

extension View {
    func accentButtonStyle() -> some View {
        self.modifier(AccentButtonStyle())
    }
}
