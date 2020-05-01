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
        let editVC = EditStudentInfoViewController()
        taskController.createTask(title: "Task1", note: "1", dueDate: "today", student: "114")
        XCTAssertNotNil(editVC.fetchedResultsController.fetchedObjects)
    }
    func testUpdateTask() {
        let taskController = TaskController()
        let editVC = EditStudentInfoViewController()
        
        let task = editVC.fetchedResultsController.fetchedObjects?[1]
        taskController.updateTask(task: task!, title: "TestUpdate", note: "1", taskDueDate: "today")
        
        XCTAssertEqual(task!.title, "TestUpdate")
    }
    
    func test() {
        let taskController = TaskController()
        let editVC = EditStudentInfoViewController()
        
        let task = editVC.fetchedResultsController.fetchedObjects?[1]
        taskController.delete(task: task!)
        
        XCTAssertEqual(editVC.fetchedResultsController.fetchedObjects?.count, 1)
        
    }
}
