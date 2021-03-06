//
//  CoreData.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor
//Some of these test needs pre set up object in firebase, if you cannot open my firebase, plase make your own firebase inside the controller and create objects whenever needed
class CoreData: XCTestCase {

    func testMakeProf() {
        let professor = Professor(username: "Lydia", password: "Lydia")
        XCTAssertEqual(professor.username, "Lydia")
        XCTAssertEqual(professor.password, "Lydia")
    }

    func testMakeStudent() {
        let student = Student(name: "Lydia", email: "Lydia", professor: "Lydia")
        XCTAssertEqual(student.name, "Lydia")
        XCTAssertEqual(student.email, "Lydia")
        XCTAssertEqual(student.professor, "Lydia")
    }

    func testMakeTask() {
        let task = Task(title: "Lydia", note: "Lydia", dueDate: "", student: "Lydia")
        XCTAssertEqual(task.note, "Lydia")
        XCTAssertEqual(task.title, "Lydia")
        XCTAssertNotNil(task.dueDate)

    }

}
