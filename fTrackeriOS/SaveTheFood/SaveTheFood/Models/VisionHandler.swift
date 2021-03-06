//
//  VisionHandler.swift
//  SaveTheFood
//
//  Created by Philip Tam on 2019-01-26.
//  Copyright © 2019 savethefood. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VisionHandler {
    
    static let shared: VisionHandler = VisionHandler()
    
    func detect(data: String, completion: @escaping (String?) -> Void) { // Check only if the completion is true
        
        DispatchQueue.global(qos: .background).async {
            
            let params: [String: Any] =
                ["requests":
                    ["image" :
                        ["content": data],
                     "features":[
                        "type":"LABEL_DETECTION",
                        ],
                     ]
                ]
            
            
            let url = "https://vision.googleapis.com/v1/images:annotate"
            
            let headers = ["X-Goog-Api-Key": APIKey, "Content-Type": "application/json; charset=utf-8"]
            
            let manager = Alamofire.SessionManager.default
            
            // Request Timeout
            manager.session.configuration.timeoutIntervalForRequest = 30
            manager.session.configuration.timeoutIntervalForResource = 30
            
            let request = manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    do {
                        if let data = response.data {
                            let json = try JSON.init(data: data)
                            print("Got data")
                            print(json)
                            
                            guard let result = json.dictionary?["responses"] else {
                                print("Failed to make dictionaryValue")
                                return
                            }
                            print(result)
                            print(result.first)
                            guard let results = result.first?.1.dictionaryObject?["labelAnnotations"] as? [[String: Any]] else {
                                print("Faileddddd")
                                return
                            }
                        
                            var highestLabel: [String: Any] = [:]
                            for res in results {
                                guard let description = res["description"] as? String else {return}
                                if description.lowercased().elementsEqual("apple") {
                                    highestLabel = res
                                    break
                                } else if description.lowercased().elementsEqual("clementine") {
                                    highestLabel = res
                                    break
                                } else if description.lowercased().elementsEqual("banana"){
                                    highestLabel = res
                                    break
                                } else {
                                    highestLabel = results.first ?? [:]
                                }
                            }
                            
                            
                            
                            FirebaseHandler.shared.sendToFirebase(data: highestLabel, { (success, error) in
                                if success {
                                    if let label = highestLabel["description"] as? String {
                                        completion(label)
                                    } else {
                                        completion("failed")
                                    }
                                    
                                } else {
                                    if let error = error {
                                        print("Error \(error)")
                                    }
                                }
                            })
                            
                        } else {
                            print("Failed")
                        }
                    } catch {
                        print("Error \(error)")
                    }
                    break
                case .failure(let error):
                    print("Error \(error)")
                }
            })
        }
    }
}
