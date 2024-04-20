//
//  ModalJoinView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-03-17.
//  Copyright Lukas Timusk 2024

// TODO: MAKE THE GOD DAMN BAR NAME FROM FIREBASE WORK

import SwiftUI

struct ModalJoinView: View {
    
    // *******************************************
    // ************* OUR VARIABLES ***************
    // *******************************************
    
    @State private var bar: GitHubBar?
    @State var FBBarjoin: String
    @State var FBMaxBarCapacity: Int
    
    
    // IF THE MODAL VIEW IS SHOWING
    @Binding var showingBottomSheet: Bool
    
    // IF THE USER HAS JOINED A LIST
    @Binding var joinedlist: Bool
    @Binding var listCounter: Int
    
    @State private var isPressed = false
    @State private var isPressed2 = false
    @State private var showError = false
    // @State private var showingJoinAlert: Bool = false
    @State private var activeAlert: ActiveAlert? // Changed from Bool to ActiveAlert

    @State private var authViewski = AuthViewModel()
    @State private var capacityResult: Int = 300

    
    @EnvironmentObject var viewModel: AuthViewModel
    @ObservedObject var db2 = DatabaseConnector()
    
    let defaults = UserDefaults.standard
    let dbConnector = DatabaseConnector()
    
    
    enum ActiveAlert: Identifiable { // Conform ActiveAlert to Identifiable
        case joinError, capacityFull
        
        var id: Int { // Provide a unique identifier for each case
            switch self {
            case .joinError:
                return 0
            case .capacityFull:
                return 1
            }
        }
    }
    
    struct Keys {
        static let joinedAList = "joinedAList"
        static let joinedThisList = "joinedThisList"
        static let numLists = "numLists"
    }
    
    // ***************** BODY ***********************
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let buttonWidth = geometry.size.width / 2.2
            
            VStack{
                
                Spacer()
                
                
                
                if joinedlist == true {
                    Text("Leave \(FBBarjoin)'s Guest List?")
                        .font(Font.custom("UberMove-Bold", size: 23))
                    
                    
                } else {
                    
                    Text("Join \(FBBarjoin)'s Guest List?")
                        .font(Font.custom("UberMove-Bold", size: 23))
                    
                    
                }
                
                
                // ************************ LEAVE AND JOIN ********************
                
                HStack {
                    
                    // ******** JOIN BUTTON **********
                    
                    // If the user hasn't joined a list yet:
                    if joinedlist == false {
                        
                        Button(action: {
                            
                            if globalListCounter > 0 {
                                
                                print("actioned!")
                                //showingJoinAlert.toggle()
                                self.activeAlert = .joinError // Changed from 'showingJoinAlert.toggle()' to set activeAlert
                                
                            } else if capacityResult >= FBMaxBarCapacity {
                                self.activeAlert = .capacityFull // Set activeAlert based on capacity
                                
                            }
                            else {
                                showingBottomSheet = false
                                joinedlist = true
                                globalListCounter += 1
                                
                                
                                // Add name to firebase
                                saveToDb(nameforGL: authViewski.currentUser?.fullName ?? "**** ERROR IN JOIN NAME AUTH ****", idforGL: authViewski.currentUser?.id ?? "**** ERROR IN JOIN ID AUTH ****")
         
                               
                            }
                            
                            
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.green)
                                    .frame(width: buttonWidth, height: 80)
                                Text("Join")
                                    .font(.custom("Helvetica", size: 20))
                                    .foregroundColor(.white)

                            }
                            .opacity(isPressed ? 0.1 : 1.0)
                            .scaleEffect(isPressed ? 1.1 : 1.0)
                            
                            
                        }
                        .alert(item: $activeAlert) { alertType in // Changed from 'isPresented' to 'item' and added closure
                            switch alertType {
                            case .joinError:
                                return Alert(title: Text("Error: cannot join more than one guest list"))
                            case .capacityFull:
                                return Alert(title: Text("Error: bar at full capacity"))
                            }
                        }
                        
                        
                        
                        
                        
                    } else {
                        
                        // ******** LEAVE BUTTON **********
                        
                        Button(action: {
                            
                            showingBottomSheet = false
                            joinedlist = false
                            
                            globalListCounter = globalListCounter - 1
                            
                            
                            
                            //LEAVE IN FIREBASE
                            leave(nameforGL: authViewski.currentUser?.fullName ?? "ERROR IN LEAVE NAME AUTH", idforGL: authViewski.currentUser?.id ?? "ERROR IN LEAVE ID AUTH")
                        
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(.red)
                                    .frame(width: buttonWidth, height: 80)
                                Text("Leave")
                                    .font(.custom("Helvetica", size: 20))
                                    .foregroundColor(.white)
                            }
                            .opacity(isPressed ? 0.1 : 1.0)
                            .scaleEffect(isPressed ? 1.1 : 1.0)
                            
                            
                        } // End of Leave button
                        
                    }
                    
                    
                    
                    
                    
                    // ******** CANCEL BUTTON **********
                    Button(action: {
                        
                        showingBottomSheet = false
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray)
                                .frame(width: buttonWidth, height: 80)
                            Text("Cancel")
                                .foregroundColor(.black)
                                .font(.custom("Helvetica", size: 20))
                            
                        }
                        .opacity(isPressed2 ? 0.1 : 1.0)
                        .scaleEffect(isPressed2 ? 1.1 : 1.0)
                       
                    }
                    
                }
                .padding(.vertical, 10)
                
                Text("Current capacity: \(capacityResult)/\(FBMaxBarCapacity)")
                    .font(Font.custom("UberMove-Bold", size: 18))
                
                
                Spacer()
                
                
                
                
            }
            .task {
                do {
                    let capacity = try await getBarCapacity()
                    capacityResult = capacity
                } catch {
                    print("Error: \(error)")
                }
            }
            
            .padding()
          
            
            
            
            
            // ***************** END BODY ***********************
            
            .task {
                do {
                    bar = try await getBar3()
                } catch {
                    if let error = error as? GHError {
                        switch error {
                        case .invalidURL:
                            print("Invalid URL")
                        case .invalidResponse:
                            print("Invalid Response")
                        case .invalidData:
                            print("Invalid Data")
                        }
                    } else {
                        print("Unknown error: \(error)")
                    }
                }
            }
        }
        
    }
    
    
    func getBar3() async throws -> GitHubBar {
        let endpoint = "https://lukastimusk.github.io/Barski/bars.json"
        
        guard let url = URL(string: endpoint) else { throw GHError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubBar.self, from: data)
        } catch{
            throw GHError.invalidData
        }
        
    }
    
    
    func saveToDb(nameforGL: String, idforGL: String) {
        dbConnector.joinGL(userId: idforGL, name: nameforGL, barName: FBBarjoin)
        print("**** JOINED GUEST LIST ****")
    }
    
    func getBarCapacity() async throws -> Int {
        do {
            
            print("RUN MY FUNCTION RAN BABY ")
            let barCapacity = try await dbConnector.countCapacity2(barname: FBBarjoin)
            print("Number of documents for \(FBBarjoin): \(barCapacity)")
            // Use 'count' as needed
            return(barCapacity)
        } catch {
            print("Error: COUNTING SHIT OR SOMETHING IDK")
            throw error
        }
    }
    
    
    func leave(nameforGL: String, idforGL: String) {
        dbConnector.leaveGL(userId: idforGL, barName: FBBarjoin, name: nameforGL)
        print("**** LEFT GUEST LIST ****")
    }
    
    
}






struct ModalJoinView_Previews: PreviewProvider {
    @State static private var showingBottomSheet = false
    @State static private var joinedlist = false
    @State static private var listCounter = 0
    
    
    
    static var previews: some View {
        ModalJoinView(FBBarjoin: "Example", FBMaxBarCapacity: 100, showingBottomSheet: $showingBottomSheet, joinedlist: $joinedlist, listCounter: $listCounter)
    }
}
