/* Copyright (C) 2024 Lukas Timusk - All Rights Reserved */

/*
 
 TODO LIST :
 
 - add address to API Call


 */

import SwiftUI
import Foundation


//******************************************* HOME VIEW STRUCTURE ***************************************

 
 
struct HomeView: View {
    @State private var bar: GitHubBar?
    @Environment(\.colorScheme) var colorScheme
    



    var body: some View {
        
        VStack{
            
            
            VStack{
                
                
                //************************* TITLE LOGO  ******************************
                
                
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
                            
                            Image("LightEventsLogo3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.bottom, 20)
                            
                        }

                        
                        
                        
                        
                        // FIRST TAB
                        
                        
                        FullAd(nameofbar: bar?.barname1 ?? "Error Loading", addressofbar: bar?.baraddress1 ?? "Waterloo",
                                adofbar: bar?.barpicture1 ?? "")
                        

                        
                        
                        
                        // SECOND TAB
                        
                        FullAd(nameofbar: bar?.barname2 ?? "Error Loading", addressofbar: bar?.baraddress2 ?? "Waterloo",
                                adofbar: bar?.barpicture2 ?? "")
                        
                        
                        
                        // THIRD TAB
                        
                        FullAd(nameofbar: bar?.barname3 ?? "Error Loading", addressofbar: bar?.baraddress3 ?? "Waterloo",
                                adofbar: bar?.barpicture3 ?? "")
                        
                        
                    }
                    
                    
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
            //.background(Color(red: 4/225, green: 36/225, blue: 76/225)) // Set the background color
            .edgesIgnoringSafeArea(.top)
            .padding(.bottom, 15)
            .background(colorScheme == .dark ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1.0))

            
            
            Spacer()
        }
    }
    
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
    
}
    
        
    

//******************************************* HEADER STRUCTURE ***************************************


struct FullAd: View {
    @State private var bar: GitHubBar?
    @Environment(\.colorScheme) var colorScheme

    
    var nameofbar: String
    var addressofbar: String
    var adofbar: String
    
    var formattedAddress: String {
        addressofbar.replacingOccurrences(of: " ", with: ",")
    }
    
    var body: some View {
        VStack{
            HStack{
                
                Image("KentuckyLogo")
                    .resizable()
                    .cornerRadius(90)
                    .padding(.vertical, 5)
                    .frame(width: 45, height: 56)
                    .padding(.leading, 15)
                
                
                Text(nameofbar)
                    .font(Font.custom("UberMove-Bold", size: 25))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .multilineTextAlignment(.center)


                    


                Spacer()

                OpenMapButton(addressofbar2: formattedAddress)

            }
            .background(colorScheme == .light ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(.white))
            .cornerRadius(80)
            .padding(.horizontal, 5)
            //.padding(.bottom, 5)

            VStack{

                AsyncImage(url: URL(string: adofbar)) { image in
                    image
                        .resizable()
                        .frame(height: 500)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorScheme == .dark ? Color.white : Color(red: 4/225, green: 36/225, blue: 76/225), lineWidth: 5)
                        )
                } placeholder: {
                    Image("KentuckyAd")
                        .resizable()
                        .frame(height: 500)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 5)
                        )
                }
            }
            .padding(.bottom, 50)
            .padding(.horizontal, 10)
        }
        .task {
            do {
                bar = try await getBar()
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
    
    
    
    
    
    func getBar() async throws -> GitHubBar {
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
    
    
    

}




// ************ MAP BUTTON **************


struct OpenMapButton: View {
    @Environment(\.colorScheme) var colorScheme

    
    var addressofbar2: String
    var body: some View {
        
        
        Button {
            //openMap(address: addressofbar2)
            OpenMapButton.openMap(address: addressofbar2) // Changed: Call the static function

        } label: {
            
            
            Image(systemName: "mappin.circle")
                .resizable()
                .padding(.trailing, 10)
                .frame(width: 60, height: 50)
                .foregroundColor(colorScheme == .light ? .white : .black)

        }
    }
    
    
    static func openMap(address: String) {
        print("address: \(address)")
        guard let url = URL(string: "http://maps.apple.com/?address=\(address)") else {
            return // Exit the function if URL cannot be created
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            return // Exit the function if app cannot open the URL
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
}









// ******************************  API METRICS **************** *****************



struct GitHubBar: Codable {
    let barname1: String
    let barpicture1: String
    let baraddress1: String
    let barrtsp1: String
    let barcapacity1: Int

    
    let barname2: String
    let barpicture2: String
    let baraddress2: String
    let barrtsp2: String
    let barcapacity2: Int

    
    let barname3: String
    let barpicture3: String
    let baraddress3: String
    let barrtsp3: String
    let barcapacity3: Int

    
    let eventslogo: String
    let toplogo: String
    let cameralogo: String
    let guestlistlogo: String

}


enum GHError: Error {
    
    case invalidURL
    case invalidResponse
    case invalidData
    
}





//******************************************* PREVIEW ***************************************


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of AuthViewModel
        let authViewModel = AuthViewModel()
        
        // Pass authViewModel as an environment object
        HomeView()
            .environmentObject(authViewModel)
    }
}

//
//
//struct HomeView_Previews: PreviewProvider {
//static var previews: some View {
//    HomeView()
//}
//}

