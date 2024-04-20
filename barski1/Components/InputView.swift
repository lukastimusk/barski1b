//
//  InputView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-17.
//

import SwiftUI

struct InputView: View {
    @Environment(\.colorScheme) var colorScheme

    
    @Binding var text:String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            
            HStack{
                
                // PASSWORD
                if isSecureField {
                    SecureField(placeholder, text: $text)
                        .font(Font.custom("UberMove-Bold", size: 15))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 10)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1) // Border
                        )
                    
                    // EMAIL / USERNAME
                } else{
                    TextField(placeholder, text:$text)
                    //.font(.system(size:13))
                        .font(Font.custom("UberMove-Bold", size: 15))
                        .padding(.horizontal, 7)
                        .padding(.vertical, 10)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 1) // Border
                        )
                    
                }
                
            }
            
            
            
            Divider()
            
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}
