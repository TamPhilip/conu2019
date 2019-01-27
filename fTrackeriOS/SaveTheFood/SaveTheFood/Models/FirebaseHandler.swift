//
//  DataFetcher.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import Foundation
import Firebase

public class FirebaseHandler {
    static let shared: FirebaseHandler = FirebaseHandler()
    
    func sendToFirebase(data: [String: Any], _ completionHandler: @escaping (Bool, Error?) -> ()) {
        Firestore.firestore().collection("history").addDocument(data: data) { (error) in
            if let error = error {
                completionHandler(false, error)
                return
            }
            completionHandler(true, nil)
        }
    }
    
    func getFirebaseData(data: [String: Any], _ completionHandler: (Bool, Error?) -> ()) {
        
    }
}
