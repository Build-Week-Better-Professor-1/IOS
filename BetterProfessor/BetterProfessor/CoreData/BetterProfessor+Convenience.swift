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
        
        return ProfessorRepresentation(
                                       username: username,
                                       password: password)
    }
    

    @discardableResult convenience init(username: String,
                                        password: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.username = username
        self.password = password
    }
    
    @discardableResult convenience init?(professorRepresentation: ProfessorRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        

        self.init(username: professorRepresentation.username,
                  password: professorRepresentation.password,
                  context: context)
    }
}
extension Task {
    var taskRepresentation: TaskRepresentation? {
        guard let title = title,
        let note = note,
            let dueDate = dueDate else {return nil}
        
        return TaskRepresentation(title: title,
        note: note,
        dueDate: dueDate)
    }
    @discardableResult convenience init(title: String,
                                        note: String,
                                        dueDate: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context:context)
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }
}

extension Student {
    
    var studentRepresentation: StudentRepresentation? {
        guard let name = name,
            let email = email,
            let professor = professor else {
                return nil
        }

        return StudentRepresentation(id: id,
                                     name: name,
                                     email: email,
                                     professor: professor)
    }
    
    @discardableResult convenience init(id: String = UUID().uuidString,
                                        name: String,
                                        email: String,
                                        professor: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.id = id
        self.professor = professor
    }
    
    @discardableResult convenience init?(studentRepresentation: StudentRepresentation,
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let id = studentRepresentation.id else {return nil}
        self.init(id: id,
                  name: studentRepresentation.name,
                  email: studentRepresentation.email,
                  professor: studentRepresentation.professor,
                  context: context)
    }
}

