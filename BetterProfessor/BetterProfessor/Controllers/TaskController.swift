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
    //Lydia's firebase for testing
    //let baseURL = URL(string: "https://betterprofessortask.firebaseio.com/")!
    let baseURL = URL(string: "https://betterprofessortasktest-2cfc9.firebaseio.com/")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    init() {

        fetchTask()
    }

    var taskRep: [TaskRepresentation] = []

    func fetchTask(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

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
                self.updateTasks(with: self.taskRep)
            } catch {
                NSLog("Error decoding JSON data when fetching student: \(error)")
                completion(error)
                return
            }

            completion(nil)

        }.resume()
    }
    
    func createTask(title: String, note: String, dueDate: String, student: String) {
        let task = Task(title: title, note: note, dueDate: dueDate, student: student)
              put(task: task)
              do {
                  try CoreDataStack.shared.save()
              } catch {
                  NSLog("Saving new task failed")
              }
        NotificationCenter.default.post(name: NSNotification.Name("TaskAdd"), object: self)
          }

    func updateTask(task: Task, title: String, note: String, taskDueDate: String) {
        task.title = title
        task.note = note
        task.dueDate = taskDueDate
        put(task: task)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Saving edited student failed")
        }
        NotificationCenter.default.post(name: NSNotification.Name("TaskChange"), object: self)
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
        let id = task.id ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
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

    private func put(task: Task, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let id = task.id ?? UUID().uuidString
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            request.httpBody = try JSONEncoder().encode(task.taskRepresentation)
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

    func updateTasks(with representations: [TaskRepresentation]) {

        let taskWithIDs = representations.filter({$0.id != nil })
        //let taskWithID = taskWithIDs.filter({$0.student == "\()"})
        
        let idToFetch = taskWithIDs.compactMap({$0.id})
        let repByID = Dictionary(uniqueKeysWithValues: zip(idToFetch, taskWithIDs))
        var tasksToCreate = repByID

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", idToFetch)
        let context = CoreDataStack.shared.container.newBackgroundContext()

        context.performAndWait {
            do {
                let existTasks = try context.fetch(fetchRequest)

                for task in existTasks {
                    guard let id = task.id else {continue}
                    guard let representation = repByID[id] else {continue}
                    self.update(task: task, with: representation)
                    tasksToCreate.removeValue(forKey: id)
                }
                for task in tasksToCreate.values {
                    Task(taskRepresentation: task, context: context)
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

    private func update(task: Task, with rep: TaskRepresentation) {
        task.id = rep.id ?? UUID().uuidString
        task.title = rep.title
        task.note = rep.note
        task.dueDate = rep.dueDate
    }
}
