//
//  GuestListView.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-03-08.
//

// TODO: Change to Guest List logo


import SwiftUI

var globalListCounter = 0

struct GuestListView: View {
    @State private var bar: GitHubBar?
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dbconnector = DatabaseConnector()
    
    var bars: [String] {
        guard let bar else { return [] }
        return [
            bar.barname1,
            bar.barname2,
            bar.barname3,
        ]
    }
    
    var maxBarCapacities: [Int] {
        guard let bar = bar else { return [] }
        let maxCapacityList = [bar.barcapacity1, bar.barcapacity2, bar.barcapacity3]
        return maxCapacityList
    }
    
    
    
    // *************************** BODY BELOW HERE ***************************
    
    var body: some View {

        VStack{
            
            
            VStack {
                
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
                
                // *************************** SCORLL VIEW CONTENT ***************************
                
                
                ScrollView (.vertical, showsIndicators: false) {
                            
                    
                    // EVENTS LOGO
                    
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
                    
                    // ACTUAL ADS
                    
                    ForEach(Array(zip(bars.indices, bars)), id: \.0) { index, item in
                        let numnum = index
                        FullAd2(buttonNumber: index + 1, nameofbar: item, maxBarCapacity: maxBarCapacities[numnum])
                    }
                    
                                    

                }
                
                Spacer()

                
                
            } // END OF BODY
            
            
            
        }
        .background(colorScheme == .dark ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(red: 246/255, green: 246/255, blue: 246/255, opacity: 1.0))        .edgesIgnoringSafeArea(.top)
        .padding(.bottom, 15)
        
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
    
    init() {
        print("Init for GLV done")
    }
    
    // *************************** END OF BODY START OF FUNCITONS ***************************
    
  
    
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
    
}



// ************************************* LABEL VIEW ******************************************

struct FullAd2: View {
    @State private var bar: GitHubBar?
    @State var showingBottomSheet = false
    @State var joinedlist: Bool = false
    @State var listCounter: Int = 0
    @State var authViewski = AuthViewModel()
    @EnvironmentObject var viewModel: AuthViewModel


    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var dbconnector2 = DatabaseConnector()

    
    
    let buttonNumber: Int
    var nameofbar: String
    var maxBarCapacity: Int
    
    init(buttonNumber: Int, nameofbar: String, maxBarCapacity: Int) {
        self.buttonNumber = buttonNumber
        self.nameofbar = nameofbar
        self.maxBarCapacity = maxBarCapacity

    }
    
    
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
                    .font(Font.custom("UberMove-Bold", size: 25))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 10)
                    .foregroundColor(colorScheme == .light ? .white : .black)

                
                Spacer()
                
                // ***** BUTTONS *******
                
                if joinedlist == true {
                    
                    Button {
                        showingBottomSheet.toggle()

                    } label: {
                        
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .padding(.trailing, 10)
                            .frame(width:70, height: 56)
                            .foregroundColor(.green)
                    }
                    
                } else {
                    
                    Button {
                        
                        showingBottomSheet.toggle()
                        
                        } label: {
                        
                        Image(systemName: "x.circle")
                            .resizable()
                            .padding(.trailing, 10)
                            .frame(width:70, height: 56)
                            .foregroundColor(.red)
                    }
                    
                }

                
                
                // **** END OF BUTTONS *****
                
            }
            .background(colorScheme == .light ? Color(red: 4/225, green: 36/225, blue: 76/225) : Color(.white))
            //.padding(.horizontal, 10)
            .cornerRadius(80)
            
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
        .sheet(isPresented: $showingBottomSheet) {
            ModalJoinView(FBBarjoin: nameofbar, FBMaxBarCapacity: maxBarCapacity, showingBottomSheet: $showingBottomSheet, joinedlist: $joinedlist, listCounter: $listCounter)
                .presentationDetents([.fraction(0.35)])
        }
        .task {
            guard let userId = viewModel.currentUser?.id else { return }
            try? await EnrolledinBar(CurrentBarName: nameofbar, userID: userId)
        }
    }
    
    
        
    
    
    // *******************   FUNCTIONS FOR LABEL  ********************
    
      
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
    
    // CURRENT = ONE IM CHECKING ********** ENROLLED = THE ONE GUEST IS ACTUALLY IN
    func EnrolledinBar(CurrentBarName: String, userID: String) async throws{
        
        var EnrolledBar: String
        EnrolledBar = try await dbconnector2.getCurrentGL(userID: userID)

        print("BAR IM CHECKING AGAINST: \(CurrentBarName)")
        print("USER ID: \(userID)")
        print("BAR USER ACTUALLY IN: \(EnrolledBar)")

        
        if EnrolledBar == CurrentBarName {
            print("ENROLLED")
            globalListCounter = 1
            joinedlist = true
            
        } else {
            print("NO MATCH FOUND")
        }
 
    }

    
    
    // ***********************   END OF LABEL   ***********************
}





struct GuestListView_Previews: PreviewProvider {
    static var previews: some View {
        GuestListView()
    
    }
}


