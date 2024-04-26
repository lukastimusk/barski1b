//
//  ReportABug.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-04-24.
//
//TODO: THROW A LITTLE ALERT THAT THANKS USER FOR REPORTING ERROR


import SwiftUI

struct ReportABug: View {
    @Binding var bugModalPresented: Bool
    @State private var userBugReport: String = ""
    @State private var isPressed3 = false
    @State private var showErrorAlert = false
    @State private var authViewski2 = AuthViewModel()
    @EnvironmentObject var viewModel: AuthViewModel


    @ObservedObject var db2 = DatabaseConnector()
    let dbConnector = DatabaseConnector()

    var body: some View {
        
        GeometryReader { geometry in
            let buttonWidth2 = geometry.size.width / 2.2
            
            VStack {
                
                Text("Please describe the bug: ")
                    .font(Font.custom("UberMove-Bold", size: 23))
                    .padding(.top, 10)
                
                TextField("Describe the bug", text: $userBugReport)
                    .font(Font.custom("UberMove-Bold", size: 16))
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 100)
                
                HStack{
                    
                    // ******* REPORT BUG BUTTON ***********
                    
                    Button(action: {
                        if userBugReport.isEmpty {
                            showErrorAlert.toggle()
                        } else {
                            dbConnector.reportBug(message: userBugReport, UserID: authViewski2.currentUser?.id ?? "Couldn't find ID for bug")
                            bugModalPresented = false
                        }
                        
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.blue)
                                .frame(width: buttonWidth2, height: 80)
                            Text("Report")
                                .font(.custom("Helvetica", size: 20))
                                .foregroundColor(.white)
                            
                        }
                        .opacity(isPressed3 ? 0.1 : 1.0)
                        .scaleEffect(isPressed3 ? 1.1 : 1.0)
                    }
                    
                    // ******* CANCEL BUTTON ***********

                    Button(action: {
                        
                        bugModalPresented = false
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray)
                                .frame(width: buttonWidth2, height: 80)
                            Text("Cancel")
                                .font(.custom("Helvetica", size: 20))
                                .foregroundColor(.black)
                            
                        }
                        .opacity(isPressed3 ? 0.1 : 1.0)
                        .scaleEffect(isPressed3 ? 1.1 : 1.0)
                    }
                    
                } // END OF HSTACK
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text("Please describe the bug before reporting"), dismissButton: .default(Text("OK")))
                }
                
            } // END OF VSTACK
        } // END OF GEOMETRY READER
    }// END OF BODY
    
}// END OF STRUCT


//
//    .sheet(isPresented: $showingBottomSheet) {
//        ModalJoinView(FBBarjoin: nameofbar, FBMaxBarCapacity: maxBarCapacity, showingBottomSheet: $showingBottomSheet, joinedlist: $joinedlist, listCounter: $listCounter)
//            .presentationDetents([.fraction(0.35)])
//    }
