//
//  LoginView.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Welcome to")
                        .foregroundColor(Color("brandPrimary"))
                        .font(.body)
                        .fontWeight(.bold)
                    Text("Wanderland")
                        .foregroundColor(Color("brandPrimary"))
                        .font(.title)
                        .fontWeight(.bold)
                }.padding(.bottom)
                
                Image(systemName: "airplane.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("brandPrimary"))
                
                VStack {
                    TextField("Username", text: $loginVM.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                    SecureField("Password", text: $loginVM.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding()
                    
                }.padding()
                
                Button(action: {
                    guard !loginVM.username.isEmpty && !loginVM.password.isEmpty else {
                        loginVM.submissionIsEmpty = true
                        return
                    }
                    loginVM.signIn(username: loginVM.username, password: loginVM.password)
                    
                }, label: {
                        StandardButton(buttonName: "Sign In")
                })
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
            }
            .padding()
            .onAppear {
                loginVM.username = ""
                loginVM.password = ""
            }
            .alert(
                "Fields cannot be empty.",
                isPresented: $loginVM.submissionIsEmpty, actions: {}
            )
            .alert(
                "User does not exist.",
                isPresented: $loginVM.userIsNotFound, actions: {}, message: {
                    Text("Click \"Create Account\" to register.")
                }
            )
            .alert(
                "Username and password do not match.",
                isPresented: $loginVM.passwordIsIncorrect, actions: {}
            )
        }
        
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
