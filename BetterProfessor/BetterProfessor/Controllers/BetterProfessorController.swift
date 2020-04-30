//
//  BetterProfessorController.swift
//  BetterProfessor
//
//  Created by Lydia Zhang on 4/28/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

let baseUrl = URL(string: "https://betterprofessortest.firebaseio.com/")!

class BetterProfessorController {

    init() {

        fetchStudent()
    }
    var token: String?
    func createStudent(name: String, email: String, professor: String) {
        let student = Student(name: name, email: email, professor: professor)
        put(student: student)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving new student failed")
        }
    }
    func updateStudent(student: Student, name: String, email: String) {
        student.name = name
        student.email = email
        put(student: student)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving edited student failed")
        }
    }
    func delete(student: Student) {
        CoreDataStack.shared.mainContext.delete(student)
        do {
            deleteStudentFromServer(student: student)
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Delete student failed")
        }
    }
    func deleteStudentFromServer(student: Student, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let id = student.id else {
            NSLog("ID is nil when trying to delete student from server")
            completion(NSError())
            return
        }
        let requestURL = baseUrl.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { (_, _, error) in
        if let error = error {
            NSLog("Error deleting student from server: \(error)")
            completion(error)
            return
        }
        completion(nil)
        }.resume()
    }
    private func put(student: Student, completion: @escaping ((Error?) -> Void) = { _ in }) {
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
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error Putting student to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    //var students: [Student] = []
    var studentRep: [StudentRepresentation] = []
    func fetchStudent(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseUrl.appendingPathExtension("json")

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

            do {
                self.studentRep = try JSONDecoder().decode([String: StudentRepresentation].self, from: data).map({$0.value})
                self.updateStudents(with: self.studentRep)
            } catch {
                NSLog("Error decoding JSON data when fetching student: \(error)")
                completion(error)
                return
            }

            completion(nil)

        }.resume()
    }

    func updateStudents(with representations: [StudentRepresentation]) {
        var tokenRep: [StudentRepresentation] = []
        guard let token = token else {return}
        for rep in representations {
            //let x = rep.professor
            if rep.professor == token {
                tokenRep.append(rep)
            }
        }
        let studentWithIDs = tokenRep.filter({$0.id != nil })
        let studentWithID = studentWithIDs.filter({$0.professor == "\(token)"})

        let idToFetch = studentWithID.compactMap({$0.id})
        let repByID = Dictionary(uniqueKeysWithValues: zip(idToFetch, studentWithID))
        var studentsToCreate = repByID

        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idToFetch)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
        student.id = rep.id ?? UUID().uuidString
        student.email = rep.email
        student.name = rep.name
    }

}
