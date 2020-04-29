//
//  BetterProfessorRepresentation.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation

struct ProfessorRepresentation: Codable {
    var username: String
    var password: String
}

struct StudentRepresentation: Codable {
    var id: String?
    var name: String
    var email: String
    var professor: String
}
struct TaskRepresentation: Codable {
    var id: String?
    var title: String
    var note: String?
    var dueDate: Date
    var student: String
}
