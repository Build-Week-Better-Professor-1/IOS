//
//  TaskTest.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/30/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor

//Some of these test needs pre set up object in firebase, if you cannot open my firebase, plase make your own firebase inside the controller and create objects whenever needed
class TaskTest: XCTestCase {

    func testCreatingTask() {
        let taskController = TaskController()

        XCTAssertNoThrow(taskController.createTask(title: "Task1", note: "1", dueDate: "today", student: "114"))
    }
    func testUpdateTask() {
        let taskController = TaskController()
        let taks = Task(title: "Task1", note: "1", dueDate: "today", student: "114")
        
        XCTAssertNoThrow(taskController.updateTask(task: taks, title: "11", note: "111", taskDueDate: "1111"))
    }
    
    func testDeleteTask() {
        let taskController = TaskController()

        
        XCTAssertNoThrow(taskController.delete(task: Task(title: "11", note: "111", dueDate: "1111", student: "114")))
        
    }
}
