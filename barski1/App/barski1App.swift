//
//  barski1App.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-17.
//

import SwiftUI
import Firebase
import UIKit

@main
struct barski1App: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var popUpManager = PopUpManager()
    
    init() {
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

