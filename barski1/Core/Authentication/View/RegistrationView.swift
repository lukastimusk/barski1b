//
//  RegistrationView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-18.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmpassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    @Environment(\.colorScheme) var colorScheme

    

    var body: some View {
        VStack{
            
            //Image
            
            Image("beermugs")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.vertical)
            
            VStack(spacing: 24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "enter your email")
                .autocapitalization(.none)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "enter your name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "enter your password",
                          isSecureField: true)
                .autocapitalization(.none)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmpassword,
                              title: "Confirm Password",
                              placeholder: "retype your password",
                              isSecureField: true)
                    .autocapitalization(.none)
                    
                    if !password.isEmpty && !confirmpassword.isEmpty {
                        if password == confirmpassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                                .padding(.bottom, 8)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                                .padding(.bottom, 8)
                            
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            
            
            
            // SIGN UP BUTTON
            Button {
                
                Task{
                    try await viewModel.createUser(withEmail: email,
                                                   password: password,
                                                   fullname: fullname)
                }
                
            } label: {
                HStack{
                    Text("SIGN UP")
                        .fontWeight(.semibold)
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
            
            
            
            // BACK TO LOGIN BUTTON
            Button {
                dismiss()
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(colorScheme == .light ? Color.blue : Color.white)
                        .frame(height: 44)
                    
                    HStack(spacing: 6){
                        Text("Already have an account?")
                        Text("Sign in")
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
}

extension RegistrationView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmpassword == password
        && !fullname.isEmpty
        
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
