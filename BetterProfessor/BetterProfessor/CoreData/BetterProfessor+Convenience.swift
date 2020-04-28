//
//  BetterProfessor+Convenience.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension Professor {
    
    var professorRepresentation: ProfessorRepresentation? {
        guard let id = identifier,
            let username = username,
            let password = password else {
                return nil
        }
        
        return ProfessorRepresentation(identifier: id,
                                       username: username,
                                       password: password)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        username: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.identifier = identifier
        self.username = username
        self.password = password
    }
    
    @discardableResult convenience init?(professorRepresentation: ProfessorRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(identifier: professorRepresentation.identifier,
                  username: professorRepresentation.username,
                  password: professorRepresentation.password,
                  context: context)
    }
}

extension Student {
    
    var studentRepresentation: StudentRepresentation? {
        guard let id = identifier,
            let name = name,
            let email = email,
            let taskNotes = taskNotes,
            let taskTitle = taskTitle,
            let taskDueDate = taskDueDate else {
                return nil
        }
        return StudentRepresentation(identifier: id,
                                     name: name,
                                     email: email,
                                     taskDueDate: taskDueDate,
                                     taskNotes: taskNotes,
                                     taskTitle: taskTitle)
    }
    
    @discardableResult convenience init(identifier: UUID = UUID(),
                                        name: String,
                                        email: String,
                                        taskNotes: String,
                                        taskTitle: String,
                                        taskDueDate: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.taskDueDate = Date()
        self.taskTitle = taskTitle
        self.taskNotes = taskNotes
    }
    
    @discardableResult convenience init?(studentRepresentation: StudentRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(identifier: studentRepresentation.identifier,
                  name: studentRepresentation.name,
                  email: studentRepresentation.email,
                  taskNotes: studentRepresentation.taskNotes,
                  taskTitle: studentRepresentation.taskTitle,
                  taskDueDate: studentRepresentation.taskDueDate,
                  context: context)
    }
}
