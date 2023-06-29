//
//  SignUpView.swift
//  ItineraryMap
//
//  Created by Elise on 6/18/23.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject private var signUpVM = SignUpViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "airplane.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("brandPrimary"))
                .padding(.bottom)
            
            VStack {
                Text("Create your account:")
                    .foregroundColor(Color("brandPrimary"))
                    .font(.body)
                    .fontWeight(.bold)
            }.padding(.bottom)
            
            VStack {
                TextField("Username", text: $signUpVM.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                SecureField("Password", text: $signUpVM.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                
            }.padding()
            
            Button(action: {
                guard !signUpVM.username.isEmpty && !signUpVM.password.isEmpty else {
                    signUpVM.submissionIsEmpty = true
                    return
                }
                if signUpVM.createUser() {
                    loginVM.signIn(username: signUpVM.username, password: signUpVM.password)
                }
                
            }, label: {
                StandardButton(buttonName: "Register")
            })
        }
        .padding()
        .alert(
            "Fields cannot be empty.",
            isPresented: $signUpVM.submissionIsEmpty, actions: {}
        )
        .alert(
            "Duplicate Username",
            isPresented: $signUpVM.isExistingUser, actions: {}, message: {
                Text("\"\(signUpVM.username)\" is already in use. Please choose a different username.")
            }
        )
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
