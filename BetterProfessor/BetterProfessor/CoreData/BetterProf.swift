//
//  BetterProf.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    var userRepresentation : UserRepresentation {
        
    }
    @discardableResult convenience init(username: String,
        password: String,
        identifier: UUID = UUID(),
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.identifier = identifier
        self.username = username
        self.password = password
    }
}

struct Bearer: Codable {
    let token: String
}

extension Student {
    @discardableResult convenience init(name: String,
        email: String,
        taskDueDate: Date?,
        taskTitle: String,
        taskNote: String?,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
    
        self.init(context: context)
        self.name = name
        self.email = email
        self.taskNote = taskNote
        self.taskTitle = taskTitle
        self.taskTitle = taskTitle
    }
}
