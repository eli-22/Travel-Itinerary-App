//
//  HomeScreenView.swift
//  ItineraryMap
//
//  Created by Elise on 2/3/23.
//

import SwiftUI

struct HomeScreenView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @State var user: UserViewModel
    
    var body: some View {
        ZStack {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    VStack (alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Hi there!")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        Text("What would you like to do?")
                            .font(.subheadline)
                            .foregroundColor(Color("brandSecondary"))
                            .fontWeight(.light)
                            .padding(.bottom, 10)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    NavigationLink(destination: CreateTripView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("brandPrimary"))
                                .frame(height: 55)
                            HStack {
                                Text("Create a trip")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                Image(systemName: "plus.circle")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    NavigationLink(destination: AllTripsView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("brandPrimary"))
                                .frame(height: 55)
                            HStack {
                                Text("Manage a trip")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                Image(systemName: "pencil")
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                
                VStack (alignment: .leading) {
                    
                    Text("Featured Destinations")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    Text("Need ideas?")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color("brandSecondary"))
                    Text("Check out this month's custom-designed itineraries from our team of travel experts.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color("brandSecondary"))
                        .padding(.bottom, 10)
                    VStack (spacing: 20) {
                        VStack (alignment: .leading) {
                            Text("Peru")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("21 Days")
                            Image("machu-picchu")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 270)
                                .cornerRadius(10)
                        }
                        VStack (alignment: .leading) {
                            Text("New York City")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("4 Days")
                            Image("nyc-skyline")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 270)
                                .cornerRadius(10)
                        }
                        VStack (alignment: .leading) {
                            Text("British Columbia")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text("7 Days")
                            Image("canada")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 270)
                                .cornerRadius(10)
                        }
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            loginVM.isSignedIn = false
                        }, label: {
                                StandardButton(buttonName: "Sign Out")
                        })
                        Spacer()
                    }
                }
            }
            .foregroundColor(Color("brandPrimary"))
            .padding()
        }
        
    }
}

//struct HomeScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeScreenView()
//    }
//}
