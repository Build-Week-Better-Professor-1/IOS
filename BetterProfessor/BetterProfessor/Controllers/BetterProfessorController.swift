//
//  BetterProfessorController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

let baseUrl = URL(string: "https://betterprofessorapp.herokuapp.com/api")!
let studentURL = baseUrl.appendingPathComponent("/api/students")

class BetterProfessorController {
    
    func fetchStudent(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = studentURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching entries from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            var studentRep: [StudentRepresentation] = []
            
            do {
                studentRep = try JSONDecoder().decode([String: StudentRepresentation].self, from: data).map({$0.value})
                self.updateStudents(with: studentRep)
            } catch {
                NSLog("Error decoding JSON data when fetching student: \(error)")
                completion(error)
                return
            }
            
            completion(nil)

        }.resume()
    }
    
    func updateStudents(with representations: [StudentRepresentation]) {
        
        let studentWithID = representations.filter({Int($0.id) != nil})
        let idToFetch = studentWithID.compactMap({Int($0.id)})
        let repByID = Dictionary(uniqueKeysWithValues: zip(idToFetch, studentWithID))
        var studentsToCreate = repByID
        
        
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existStudents = try context.fetch(fetchRequest)
                
                for student in existStudents {
                    let id = Int(student.id)
                    guard let representation = repByID[id] else {continue}
                    self.update(student: student, with: representation)
                    studentsToCreate.removeValue(forKey: id)
                }
                for student in studentsToCreate.values {
                    Student(studentRepresentation: student, context: context)
                }
            } catch {
                NSLog("Error fetching student: \(error)")
            }
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("save failed when updating students")
            }
        }
        
    }
    
    private func update(student: Student, with rep: StudentRepresentation) {
        student.id = rep.id
        student.email = rep.email
        student.name = rep.name
        student.taskNotes = rep.taskNotes
        student.taskTitle = rep.taskTitle
        student.taskDueDate = rep.taskDueDate
    }
}
