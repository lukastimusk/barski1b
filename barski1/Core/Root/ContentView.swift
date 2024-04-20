//
//  ContentView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-17.
//

import SwiftUI

struct ContentView: View {
    
    // ******* VARIABLES *******
    @EnvironmentObject var viewModel: AuthViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var loggedIn = false

    
    var tabBackgroundColor: Color {
        return colorScheme == .light ? Color(.white) : Color(red: 4/225, green: 36/225, blue: 76/225)
    }


    var body: some View {
        Group {
            //if viewModel.userSession != nil {
            if loggedIn == true {
                

                
                
                TabView {
                    HomeView()
                        .tabItem {
                            
                            VStack{
                                Image(systemName: "house")
                                Text("Home")
                            }

                        }
                        .background(tabBackgroundColor)


                    CameraView()
                        .tabItem {
                            Image(systemName: "camera")
                                
                            Text("Cameras")
                        }
                        .background(tabBackgroundColor)

                    GuestListView()
                        .tabItem {
                            Image(systemName: "list.clipboard")

                            Text("Guestlists")
                        }
                        .background(tabBackgroundColor)

                    

                    ProfileView()
                        .tabItem {
                            Image(systemName: "gearshape")
                                .foregroundColor(Color(.white))
                            Text("Profile")
                            
                        }
                        .background(tabBackgroundColor)



                }
                .tint(colorScheme == .light ? Color(.black) : Color(.white))
                .edgesIgnoringSafeArea(.top)
                //.background(tabBackgroundColor)
                
                
            } else {
                LoginView()
            }
        }
        .onReceive(viewModel.$userSession) { userSession in
            loggedIn = userSession != nil
            printUserSession()
        }
        
    }
    
    func printUserSession() {
        if let userSession3 = viewModel.userSession {

            print("WE PRING USER SESSION NOW User Session:", userSession3)
        } else {
            print("User Session is nil")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
