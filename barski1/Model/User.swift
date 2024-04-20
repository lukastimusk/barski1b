//
//  User.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-18.
//

import Foundation

struct User: Identifiable, Codable{
    
    let id: String
    let fullName: String
    let email: String
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

