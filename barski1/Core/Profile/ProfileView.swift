//
//  ProfileView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-18.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        if let user = viewModel.currentUser {
            
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                        
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .foregroundColor(.gray)
                            
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                Section("General"){
                    
                    HStack {
                        SettingsRowView(imagename: "gear",
                                        title: "Version",
                                        tintColor: Color(.systemGray))

                        
                        
                        
                        
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    
                    
                }
                
                Section("Account"){
                    
                    
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imagename: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)

                        }
                        
                        
                        
//                        Button {
//                            print("Delete account")
//                        } label: {
//                            SettingsRowView(imagename: "x.circle.fill",
//                                            title: "Delete Account",
//                                            tintColor: .red)
//
//                        }
                    
                    
                }
                
                
            }
            .padding(.bottom, 20)
            //.background(colorScheme == .dark ? Color(.systemGray) : Color(UIColor.systemBackground))


            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
