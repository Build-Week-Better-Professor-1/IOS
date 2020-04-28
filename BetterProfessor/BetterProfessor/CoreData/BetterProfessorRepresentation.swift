//
//  UserRepresentation.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct BetterProfessorRepresentation: Equatable, Codable {
    var identifier: UUID?
    var username: String
    var password: String
    var studentEmail: String
    var studentName: String
    var taskDueDate: Date
    var taskNote: String
    var taskTitle: String
}
