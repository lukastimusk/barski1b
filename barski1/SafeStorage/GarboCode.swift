//
//  GarboCode.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-04-04.
//


//
//
//func returnCurrentGL() {
//    print("lets run it")
//    dbconnector2.deduceGL()
//       guard let currentUserID = authViewski.currentUser?.id else {
//            print("have to exit")
//            return // Exit if current user ID is not available, SHOULD NEVER HAPPEN
//     }
//    let currentUserID = authViewski.currentUser?.id ?? "BIG UH OH"
//    print("CURRENT USER ID: \(currentUserID)")
//    var isUserInGL = false
//
//    for glDataModel in dbconnector2.CurrentGLList {
//        print("Current Guest List: \(glDataModel.CurrentGL)")
//        if glDataModel.id == currentUserID {
//            print("ID MATCH FOUND")
//
//            if glDataModel.CurrentGL == nameofbar {
//                print("BAR MATCH FOUND: \(currentUserID)")
//                isUserInGL = true
//                break // Break out of the loop once user is found in the list
//            } else {
//                print("Not a bar name match")
//            }
//
//        } else {
//            print("Not an id match")
//        }
//    }
//    print("Match: \(isUserInGL)")
//    joinedlist = isUserInGL
//}
