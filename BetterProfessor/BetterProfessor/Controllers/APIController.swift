//
//  APIController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case badUrl
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}



class APIController {    
    private let baseUrl = URL(string: "https://betterprofessorapp.herokuapp.com/api")!
    
    // create function for sign in
    var bearer: Bearer?
    func signIn(with user: Professor,completion: @escaping (Error?) -> ()) {
        let signInURL = baseUrl.appendingPathComponent("auth/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let signInRep = ["email": "\(user.professorRepresentation!.username)",
            "password": "\(user.professorRepresentation!.password)"]
        do {
            let jsonData = try jsonEncoder.encode(signInRep)
            request.httpBody = jsonData
        } catch {
            NSLog("Encode error in sign in")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                NSLog("Response: \(response)")
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            do {
                let result = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = result
                completion(nil)
            } catch {
                NSLog("1")
            }
        }.resume()
        
    }
    
    func signUp(with user: Professor, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("auth/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        
        let signUpRep = ["name": "",
                         "email": "\(user.professorRepresentation!.username)",
            "password": "\(user.professorRepresentation!.password)"]
        
        do {
            let jsonData = try jsonEncoder.encode(signUpRep)
            request.httpBody = jsonData
        } catch {
            NSLog("Encode error in sign up")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let response = response as? HTTPURLResponse{
                NSLog("Response: \(response)")
                completion(nil)
                return
            }
            
            completion(nil)
        }.resume()
        
    }

}
