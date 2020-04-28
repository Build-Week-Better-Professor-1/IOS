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
    
    init(){
        fetchStudent()
    }
    func createStudent(name: String, email: String, taskNotes: String,taskTitle: String, taskDueDate: Date) {
        let student = Student(name: name, email: email, taskNotes: taskNotes, taskTitle: taskTitle, taskDueDate: taskDueDate)
        put(student: student)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving new student failed")
        }
    }
    func updateStudent(student: Student, name: String, email: String, taskNotes: String,taskTitle: String, taskDueDate: Date) {
        student.name = name
        student.email = email
        student.taskDueDate = taskDueDate
        student.taskTitle = taskTitle
        student.taskNotes = taskNotes
        put(student: student)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving edited student failed")
        }
    }
    
    private func put(student: Student, completion: @escaping ((Error?) -> Void) = { _ in }){
        let id = student.id ?? UUID().uuidString
        let requestURL = baseUrl.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(student.studentRepresentation)
        } catch {
            NSLog("Error encoding in put method: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data,_,error in
            if let error = error {
                NSLog("Error PUTting student to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
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
        
        let studentWithID = representations.filter({$0.id != nil })
        let idToFetch = studentWithID.compactMap({$0.id})
        let repByID = Dictionary(uniqueKeysWithValues: zip(idToFetch, studentWithID))
        var studentsToCreate = repByID
        
        
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existStudents = try context.fetch(fetchRequest)
                
                for student in existStudents {
                    guard let id = student.id else {continue}
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
        student.id = (rep.id ?? nil)!
        student.email = rep.email
        student.name = rep.name
        student.taskNotes = rep.taskNotes
        student.taskTitle = rep.taskTitle
        student.taskDueDate = rep.taskDueDate
    }
    
    
}
