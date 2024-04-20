//
//  SettingsRowView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-18.
//

import SwiftUI

struct SettingsRowView: View {
    @Environment(\.colorScheme) var colorScheme

    //Input perameters
    
    let imagename: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imagename)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .white : .black)        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imagename: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
