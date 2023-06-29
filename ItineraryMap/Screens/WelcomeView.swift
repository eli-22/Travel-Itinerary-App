//
//  WelcomeView.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationView {
            if loginVM.isSignedIn {
                HomeScreenView(user: loginVM.userVM!)
            }
            else {
                LoginView()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
