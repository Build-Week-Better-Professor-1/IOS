//
//  UserRepresentation.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var identifier: String?
    var username: String
    var password: String
}
