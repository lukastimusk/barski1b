//
//  File.swift
//  barski1
//
//  Created by Lukas Timusk on 2024-03-24.
//

// TODO: Ensure that user's with same name do not get overided data in joinGL func

import FirebaseFirestore
import FirebaseAuth

class DatabaseConnector : ObservableObject {
    @Published var isProcessing = false
    @Published var CurrentGLList = [CurrentGLDataModel]()
    
    
    // rename to join
    func joinGL(userId: String, name: String, barName: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
    
        
        // date = Date() -> format to string yyy-MM-dd
        Firestore.firestore().collection(barName)
            .document(todayDateString)
            .collection("List")
            .document(name)
            .setData(["name": name, "joinedAt": Date().timeIntervalSince1970])
        
        Firestore.firestore().collection("usersGL")
            .document(todayDateString)
            .collection(userId)
            .document(userId)
            .setData(["CurrentGL": barName, "id": userId])
            print("**** FIRESTORE FIRED ****")

    }
    
    func leaveGL(userId: String, barName: String, name: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
        
        
        Firestore.firestore().collection(barName)
            .document(todayDateString)
            .collection("List")
            .document(name)
            .delete()
        
        Firestore.firestore().collection("usersGL")
            .document(todayDateString)
            .collection(userId)
            .document(userId)
            .delete()

    }
    
    
    
    func getCurrentGL(userID: String) async throws -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())

        let snapshot2 = try await Firestore.firestore().collection("usersGL").document(todayDateString).collection(userID).document(userID).getDocument()
        
        guard let data = snapshot2.data(), let currentBar = data["CurrentGL"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        print("USER IS CURRENTLY IN: \(currentBar)")
        return(currentBar)

    }
    
    func countCapacity2(barname: String) async throws -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())

        let snapshot = try await Firestore.firestore()
            .collection(barname)
            .document(todayDateString)
            .collection("List")
            .getDocuments()
        
        let numberOfDocuments = snapshot.documents.count
        print("NUMBO OF DOCS: \(numberOfDocuments)")

        return numberOfDocuments
    }
    
    
    
    func countCapacity(barname: String, completion: @escaping (Int?, Error?) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
        
        let db3 = Firestore.firestore()
     
        // count number of documents here
        
        
        db3.collection("usersGL")
            .document(todayDateString)
            .collection("List")
            .getDocuments { snapshot, error in

            // Check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    
                    print("GOT IN \(barname)s LIST ")
                    let numberOfDocuments = snapshot.documents.count
                    print("Number of documents: \(numberOfDocuments)")
                    // You can use 'numberOfDocuments' as needed
                    
                    completion(numberOfDocuments, nil)

                }
                
            }
                else {
                    print("**** ERROR IN COUNT CAPACITY GL FUNCTION")
                }
            }
        
        
    }
    
    
}
