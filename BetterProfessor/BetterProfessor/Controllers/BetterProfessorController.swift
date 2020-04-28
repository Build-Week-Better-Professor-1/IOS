//
//  BetterProfessorController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

let baseUrl = URL(string: "https://betterprofessorapp.herokuapp.com/api")!
let studentURL = baseUrl.appendingPathComponent("/api/students")

class BetterProfessorController {
    
    func fetchStudent(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = studentURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            var studentRep: [StudentRepresentation]
            
            do {
                //try JSONDecoder.decode([x, String: StudentRepresentation].self, from: data)
            } catch {
                
            }
        }
    }
    
    
}
