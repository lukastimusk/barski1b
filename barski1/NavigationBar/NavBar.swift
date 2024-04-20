//
//  NavBar.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case house
    case camera
    case gearshape
}

struct NavBar: View {
    @Binding var selectedTab: Tab
    private var fillImage: String {
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack{
            HStack{
                
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(1.5)
                        
                    
                    Spacer()
                }
                
            }
            
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
            
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(selectedTab: .constant(.house))
    }
}
