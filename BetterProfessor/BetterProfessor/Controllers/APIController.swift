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
    var bearer: Bearer?
    
    // create function for sign in
    func signIn(with user: Professor,completion: @escaping (Error?) -> ()) {
        let signInURL = baseUrl.appendingPathComponent("auth/login")
        
        var request = URLRequest(url: signInURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user.professorRepresentation)
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
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
            } catch {
                NSLog("Error decoding bearer object: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func signUp(with user: Professor, completion: @escaping (Error?) -> ()) {
        let signUpURL = baseUrl.appendingPathComponent("auth/register")
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user.professorRepresentation)
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
