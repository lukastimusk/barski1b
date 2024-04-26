//
//  AuthViewModel.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-18.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI


protocol AuthenticationFormProtocol {
    var FormIsValid: Bool { get }
}

@MainActor


class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isloggedin: Bool = false


    
    
    init() {
        
        self.userSession = Auth.auth().currentUser

        
        Task {
            await fetchUser()
        }
        
    }
    
    func signIn(withEmail email:String, password: String) async throws {
        
        if let userSession2 = userSession {
            print("***** User Session ONE: ******", userSession2)
        } else {
            print("***** User Session ONE is nil ******")
        }
        
        do {
            // these parameters are passed in through the login view when form filled in
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            self.isloggedin = true
            
        } catch {
            print("Debug, failed to log in with error \(error.localizedDescription)")
            
            if error.localizedDescription == "The supplied auth credential is malformed or has expired." {
                showAlert(message: "Invalid Username or Password")
            } else {
                showAlert(message: error.localizedDescription)
                
            }
        }
        
        if let userSession2 = userSession {
            print("***** User Session TWO: ******", userSession2)
        } else {
            print("***** User Session TWO is nil ******")
        }
        
    }
    
    func createUser(withEmail email:String, password: String, fullname: String) async throws{
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            print("*********** USER ID:", user.id)
            let encodedUser = try Firestore.Encoder().encode(user)
            
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            
            // getting data right away for profile
            await fetchUser()
            
            self.isloggedin = true
            
        } catch {
            print("********** EMAIL: ", email)
            print()
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            showAlert(message: (error.localizedDescription))
            
            
        }
        
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // Signs out user on backend
            
            self.userSession = nil // Wipes out user session, takes us back to the login screen
            self.currentUser = nil // Makes the current user data model nil
            
            self.isloggedin = false

            // Navigate back to RegistrationView after signing out
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(
                    rootView: LoginView().environmentObject(self)
                )
                window.makeKeyAndVisible()
            

            }
            
           

        } catch {
            print("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert on the topmost window scene's window
        if let topWindowScene = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first,
           let topWindow = topWindowScene.windows.last {
            
            topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}



