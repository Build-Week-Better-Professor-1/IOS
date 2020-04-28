//
//  BetterProf.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension BetterProfessor {
    
    var betterProfessorRepresentation: BetterProfessorRepresentation? {
        
        guard let id = identifier,
            let username = username,
            let password = password,
            let studentName = studentName,
            let studentEmail = studentEmail,
            let taskDueDate = taskDueDate,
            let taskNote = taskNote,
            let taskTitle = taskTitle else {
                return nil
        }
        
        return BetterProfessorRepresentation(identifier: id,
                                             username: username,
                                             password: password,
                                             studentEmail: studentEmail,
                                             studentName: studentName,
                                             taskDueDate: taskDueDate,
                                             taskNote: taskNote,
                                             taskTitle: taskTitle)
        
    }
    
    @discardableResult convenience init(username: String,
                                        password: String,
                                        studentName: String,
                                        studentEmail: String,
                                        taskDueDate: Date = Date(),
                                        taskNote: String,
                                        taskTitle: String,
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.username = username
        self.password = password
        self.studentName = studentName
        self.studentEmail = studentEmail
        self.taskDueDate = taskDueDate
        self.taskNote = taskNote
        self.taskTitle = taskTitle
        self.identifier = identifier
    }
}
