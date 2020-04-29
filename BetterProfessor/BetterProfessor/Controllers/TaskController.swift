//
//  TaskController.swift
//  BetterProfessor
//
//  Created by Chris Dobek on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    
    // MARK: - Properties
    let baseURL = URL(string: "https://betterprofessortask.firebaseio.com/")!
    
    var apiController: APIController?
    
    init(){
        
        fetchTask()
    }
    
    var taskRep: [TaskRepresentation] = []
    
    
    func fetchTask(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseUrl.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching task from server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                self.taskRep = try JSONDecoder().decode([String: TaskRepresentation].self, from: data).map({$0.value})
                //self.updateStudents(with: self.studentRep)
            } catch {
                NSLog("Error decoding JSON data when fetching student: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
    func createTask(title: String, note: String, dueDate: Date) {
        let task = Task(title: title, note: note, dueDate: Date())
              put(task: task)
              do {
                  try CoreDataStack.shared.save()
              } catch {
                  NSLog("Saving new student failed")
              }
          }
    
    func updateTask(task: Task, title: String, note: String, taskDueDate: Date) {
        task.title = title
        task.note = note
        put(task: task)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving edited student failed")
        }
    }
    
    func delete(task: Task) {
        CoreDataStack.shared.mainContext.delete(task)
        do {
            deleteTaskFromServer(task: task)
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Delete student failed")
        }
    }
    
    func deleteTaskFromServer(task: Task, completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let title = task.title else {
            NSLog("ID is nil when trying to delete student from server")
            completion(NSError())
            return
        }
        let requestURL = baseUrl.appendingPathComponent(title).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
        if let error = error {
            NSLog("Error deleting student from server: \(error)")
            completion(error)
            return
        }
        completion(nil)
        }.resume()
    }

    private func put(task: Task, completion: @escaping ((Error?) -> Void) = { _ in }){
        let title = task.title
        let requestURL = baseUrl.appendingPathComponent(title ?? " ").appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(title)
        } catch {
            NSLog("Error encoding in put method: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { data,_,error in
            if let error = error {
                NSLog("Error Putting student to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
