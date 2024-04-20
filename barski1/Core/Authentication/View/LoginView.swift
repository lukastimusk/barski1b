//
//  LoginView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-17.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel : AuthViewModel
    @Environment(\.colorScheme) var colorScheme

    
//    init() {
//        if NetworkMonitor.shared.isConnected {
//            print("WIFI CONNECTED IN LOGIN")
//        }
//        else {
//            print("WIFI NOT CONNECTED IN LOGIN")
//        }
//
//    }

    
    
    var body: some View {
        NavigationStack{
            VStack{
                
                //Image
                
                Image("beermugs")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.vertical)
                
                //Form Fields
                VStack(spacing: 24){
                    
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "enter your email")
                    .autocapitalization(.none)
                    
                    
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "enter your password",
                              isSecureField: true)
                    
                }
                .padding(.horizontal)
                

                //Sign in Button
                
                Button {
                    Task{
                        try await viewModel.signIn(withEmail: email,
                                                   password: password)
                    }
                    
                } label: {
                    HStack{
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                            .font(Font.custom("UberMove-Bold", size: 20))

                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(colorScheme == .light ? Color.white : Color(red: 4/225, green: 36/225, blue: 76/225))
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(colorScheme == .dark ? Color.white : Color(red: 4/225, green: 36/225, blue: 76/225))
                .disabled(!FormIsValid)
                .opacity(FormIsValid ? 1.0 : 0.5)
                .cornerRadius(15)
                .padding(.top, 24)
            
                
                
                Spacer()
                
                //Sign up Button
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(colorScheme == .light ? Color.blue : Color.white)
                            .frame(height: 44)
                        
                        HStack(spacing: 6){
                            Text("Don't have an account?")
                            Text("Sign up")
                                .fontWeight(.bold)
                            
                        }
                        
                    }
                    
                }
                .font(.system(size: 16))
                .font(Font.custom("UberMove-Bold", size: 16))
                .foregroundColor(colorScheme == .light ? Color.white : Color(red: 4/225, green: 36/225, blue: 76/225))
                .padding(.horizontal, 10)
                .padding(.bottom, 20)
                
                
            }
            .background(colorScheme == .dark ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1.0))
            
        }
        .onAppear {
            printUserSession()
        }
    }
    
    func printUserSession() {
        if let userSession = viewModel.userSession {
            print("***** User Session: ******", userSession)
        } else {
            print("***** User Session is nil ******")
        }
    }
    
}

extension LoginView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
