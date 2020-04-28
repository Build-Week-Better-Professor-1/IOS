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
    
    //with user: BetterProfessor
    func signIn(completion: @escaping (Error?) -> ()) {
//        let signInURL = 
    }
}
