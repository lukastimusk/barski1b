//
//  YoutubeView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-02-08.
//

import SwiftUI
import WebKit
import Foundation


struct YoutubeV: UIViewRepresentable{
    
    let youtubeID: String
    
    //Default functions
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(youtubeID)") else{return}
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
        
    }
}






//******************************************* HOME VIEW STRUCTURE ***************************************



//******************************************* HEADER STRUCTURE ***************************************


struct CameraHeader: View {
    @State private var bar: GitHubBar2?
    
    var nameofbar: String
    var addressofbar: String
    var adofbar: String

    
    var body: some View {
        VStack{
            HStack{
                
                Image("KentuckyLogo")
                    .resizable()
                    .cornerRadius(90)
                    .padding(.vertical, 10)
                    .frame(width: 50, height: 75)
                    .padding(.leading, 15)
                
                Text(nameofbar)
                    .font(Font.custom("ArialRoundedMTBold", size: 25))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                
                Spacer()
                
                Button {
                    openMap(address: addressofbar)
                } label: {
                    
                    
                    Image(systemName: "mappin.circle")
                        .resizable()
                        .padding(.trailing, 10)
                        .frame(width: 60, height: 50)
                        .foregroundColor(.black)
                }
                
            }
            .background(Color.white)
            //.padding(.horizontal, 10)
            .cornerRadius(80)
        }
        .task {
            do {
                bar = try await getBar()
            } catch {
                if let error = error as? GHError2 {
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
    
    // ***********************   FUNCTIONS FOR HEADER  ***********************
    
    func openMap(address: String) {
        if let url = URL(string: "http://maps.apple.com/?address=\(address)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    func getBar() async throws -> GitHubBar2 {
        let endpoint = "https://lukastimusk.github.io/Barski/bars.json"
        
        guard let url = URL(string: endpoint) else { throw GHError2.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
            throw GHError2.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubBar2.self, from: data)
        } catch{
            throw GHError2.invalidData
        }
        
                
    }
    
    
    // ***********************   END OF FUNCTIONS   ***********************
}




// *************** API METRICS ******************



struct GitHubBar2: Codable {
    let barname1: String
    let barpicture1: String
    let baraddress1: String
    
    let barname2: String
    let barpicture2: String
    let baraddress2: String
    
    let barname3: String
    let barpicture3: String
    let baraddress3: String
    
    let fullheaderlogo: String
    let eventslogo: String
    let toplogo: String
    let cameralogo: String

}


enum GHError2: Error {
    
    case invalidURL
    case invalidResponse
    case invalidData
    
}





