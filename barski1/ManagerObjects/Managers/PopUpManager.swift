//
//  PopUpManager.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-03-19.
//

import Foundation

final class PopUpManager: ObservableObject {
    
    enum Action {
        
        case na
        case present
        case dismiss
        
    }
    
    @Published private(set) var action: Action = .na
    
    func present() {
        
        guard !action.isPresented else {return}
        self.action = .present
        
        }
    
    func dismiss() {
        self.action = .dismiss
    }
    
}

extension PopUpManager.Action {
    
    var isPresented: Bool {self == .present}
}
