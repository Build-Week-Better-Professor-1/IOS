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
            let password = password,
            let id = id else {
                return nil
        }
        
        return ProfessorRepresentation(username: username,
                                       password: password)
    }
    
<<<<<<< HEAD
    @discardableResult convenience init(id: String,
                                        username: String,
=======
    @discardableResult convenience init(username: String,
>>>>>>> master
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
<<<<<<< HEAD
        self.id = UUID()
=======
>>>>>>> master
        self.username = username
        self.password = password
    }
    
    @discardableResult convenience init?(professorRepresentation: ProfessorRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        
<<<<<<< HEAD
        self.init(id: professorRepresentation.id?.uuidString ?? UUID().uuidString,
                  username: professorRepresentation.username,
=======
        self.init(username: professorRepresentation.username,
>>>>>>> master
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
            let professor = professor,
            let taskDueDate = taskDueDate else {
                return nil
        }
        return StudentRepresentation(id: id,
                                     name: name,
                                     email: email,
                                     taskDueDate: taskDueDate,
                                     taskNotes: taskNotes,
                                     taskTitle: taskTitle,
                                     professor: professor)
    }
    
    @discardableResult convenience init(id: String = UUID().uuidString,
                                        name: String,
                                        email: String,
                                        taskNotes: String,
                                        taskTitle: String,
                                        taskDueDate: Date,
                                        professor: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.taskDueDate = Date()
        self.taskTitle = taskTitle
        self.taskNotes = taskNotes
        self.id = id
        self.professor = professor
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
                  professor: studentRepresentation.professor,
                  context: context)
    }
}
