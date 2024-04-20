//
//  TestyView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-02-08.
//

import SwiftUI

struct TestyView: View {
    var body: some View {
        YoutubeV(youtubeID: "euktkjCMn54?si=iEeROKx0_JQWO1pX")
            .frame(width: 350, height: 190)
            .cornerRadius(30)
    }
}

struct TestyView_Previews: PreviewProvider {
    static var previews: some View {
        TestyView()
    }
}
