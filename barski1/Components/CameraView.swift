//
//  CameraView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-01-24.

// TODO: Change to Camera logo



import SwiftUI
import WebKit




struct CameraView: View {
    @State private var bar: GitHubBar?
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        
        VStack{
            
            
            VStack{
                
                
                //************************* SCROLLING BUTTON ******************************
                
                
                if colorScheme == .dark {
                    
                    AsyncImage(url: URL(string: bar?.toplogo ?? "TitleLogoIMG2")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .blendMode(.lighten)
                            .padding(.top, 45)
                        
                    } placeholder: {
                        Image("TitleLogoIMG2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .blendMode(.lighten)
                            .padding(.top, 45)

                    }
                    
                } else {
                    
                    //Image("LightTitleLogo")
                    Image("LightTitleLogo3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.top, 45)
                        .edgesIgnoringSafeArea(.top)
                        .blendMode(.normal) // Blend with white background

                }
                
                
                
                //************************* SCROLL VIEW *********************************
                
                ScrollView(.vertical, showsIndicators: false){
                    
                    
                    
                    VStack{
                        
                        
                        
                        // FIRST LOGO
                        
                        if colorScheme == .dark {
                            
                            AsyncImage(url: URL(string: bar?.eventslogo ?? "HomeLogoIMG")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .blendMode(.lighten)
                                    .padding(.bottom, 20)
                            } placeholder: {
                                Image("HomeLogoIMG")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .blendMode(.lighten)
                                    .padding(.bottom, 20)
                            }
                            
                        } else {
                            
                            
                            // ******* REPLACE LOGO HERE ******
                            Image("LightEventsLogo3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, 20)
                            
                        }
                        
                        
                        
                        // FIRST TAB
                        
                        FullCamera(nameofbar2: bar?.barname1 ?? "Placeholder", addressofbar2: bar?.baraddress1 ?? "Placeholder")
                        
                        YoutubeV(youtubeID: bar?.barrtsp1 ?? "euktkjCMn54?si=iEeROKx0_JQWO1pX")
                            .frame(width: 350, height: 190)
                            .cornerRadius(30)
                        
                        
                        // Second TAB
                        
                        FullCamera(nameofbar2: bar?.barname2 ?? "Placeholder", addressofbar2: bar?.baraddress2 ?? "Placeholder")
                            .padding(.top, 50)
                        
                        YoutubeV(youtubeID: bar?.barrtsp2 ?? "euktkjCMn54?si=iEeROKx0_JQWO1pX")
                            .frame(width: 350, height: 190)
                            .cornerRadius(30)
                        
                        
                        // Third TAB
                        
                        FullCamera(nameofbar2: bar?.barname3 ?? "Placeholder", addressofbar2: bar?.baraddress3 ?? "Placeholder")
                            .padding(.top, 50)
                        
                        YoutubeV(youtubeID: bar?.barrtsp3 ?? "euktkjCMn54?si=iEeROKx0_JQWO1pX")
                            .frame(width: 350, height: 190)
                            .cornerRadius(30)
                        
                        
                        
                        
                        
                        
                        
                        
                        //BOTTOM OF VSTACK
                    }
                    .padding(.bottom, 50)
                    .padding(.horizontal, 10)
                    
                    
                }
                
            }
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
            .background(colorScheme == .dark ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1.0))
            
            .edgesIgnoringSafeArea(.top)
            .padding(.bottom, 15)
            
            
            
            
            
            Spacer()
        }
    }

}


// ************************ FUNCTIONS *************************
        
        
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
        


struct FullCamera: View {
    @State private var bar: GitHubBar?
    @Environment(\.colorScheme) var colorScheme

    
    var nameofbar2: String
    var addressofbar2: String

    
    var body: some View {
        VStack{
            HStack{
                
                Image("KentuckyLogo")
                    .resizable()
                    .cornerRadius(90)
                    .padding(.vertical, 5)
                    .frame(width: 45, height: 56)
                    .padding(.leading, 15)
                
                Text(nameofbar2)
                    .font(Font.custom("UberMove-Bold", size: 25))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                
                Spacer()
                
                Button {
                    openMap2(address: addressofbar2)
                } label: {
                    Image(systemName: "mappin.circle")
                        .resizable()
                        .padding(.trailing, 10)
                        .frame(width: 60, height: 50)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                }
                
            }
            .background(colorScheme == .light ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(.white))
            .padding(.horizontal, 0)
            .cornerRadius(80)

            
            
            
        }
        .cornerRadius(20)
        .padding(.horizontal, 15)
        .padding(.bottom, 7)
        
        
        .task {
            do {
                bar = try await getBar2()
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
    
    // ***********************   FUNCTIONS FOR HEADER  ***********************
    
    func openMap2(address: String) {
        if let url = URL(string: "http://maps.apple.com/?address=\(address)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    func getBar2() async throws -> GitHubBar {
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
    
    
    // ***********************   END OF FUNCTIONS   ***********************
}

    
        
                
//END OF VAR BODY
    

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

