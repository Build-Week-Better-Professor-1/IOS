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
        guard let username = username,
            let password = password else {
                return nil
        }
        
        return ProfessorRepresentation(id: id,
                                       username: username,
                                       password: password)
    }
    
    @discardableResult convenience init(id: UUID,
                                        username: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.username = username
        self.password = password
    }
    
    @discardableResult convenience init?(professorRepresentation: ProfessorRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
        self.init(id: professorRepresentation.id ?? UUID(),
                  username: professorRepresentation.username,
                  password: professorRepresentation.password,
                  context: context)
    }
}

extension Student {
    
    var studentRepresentation: StudentRepresentation? {
        guard let name = name,
            let email = email,
            let taskNotes = taskNotes,
            let taskTitle = taskTitle,
            let taskDueDate = taskDueDate else {
                return nil
        }
        return StudentRepresentation(id: id,
                                     name: name,
                                     email: email,
                                     taskDueDate: taskDueDate,
                                     taskNotes: taskNotes,
                                     taskTitle: taskTitle)
    }
    
    @discardableResult convenience init(id: String,
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
        self.id = id
    }
    
    @discardableResult convenience init?(studentRepresentation: StudentRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let id = studentRepresentation.id else {return nil}
        self.init(id: id,
                  name: studentRepresentation.name,
                  email: studentRepresentation.email,
                  taskNotes: studentRepresentation.taskNotes,
                  taskTitle: studentRepresentation.taskTitle,
                  taskDueDate: studentRepresentation.taskDueDate,
                  context: context)
    }
}
