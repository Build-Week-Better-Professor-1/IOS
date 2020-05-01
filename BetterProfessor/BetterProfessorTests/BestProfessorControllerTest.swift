//
//  BestProfessorControllerTest.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor

class BestProfessorControllerTest: XCTestCase {

    func testFetchStudent() {
        let betterProfessorController = BetterProfessorController()
        let expectation = self.expectation(description: "Waiting to fetch students")

        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(betterProfessorController.studentRep.count, 1)
    }

    func testMakingStudent() {
        let betterProfessorController = BetterProfessorController()
        let dashBoard = DashboardTableViewController()

        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lambda")
        sleep(5)

        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(dashBoard.fetchedResultsController.fetchedObjects?.count, 2)

        let student = dashBoard.fetchedResultsController.fetchedObjects?[1]
        betterProfessorController.delete(student: student!)
    }

    func testDeleteStudent() {
        let betterProfessorController = BetterProfessorController()
        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lambda")
        sleep(5)

        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(betterProfessorController.studentRep.count, 2)

        let dashBoard = DashboardTableViewController()
        let student = dashBoard.fetchedResultsController.fetchedObjects?[1]

        betterProfessorController.delete(student: student!)
        sleep(5)
        XCTAssertEqual(dashBoard.fetchedResultsController.fetchedObjects?.count, 1)
    }

    func testUpdateStudent() {
        let betterProfessorController = BetterProfessorController()
        let dashBoard = DashboardTableViewController()

        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lambda")
        sleep(5)

        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(dashBoard.fetchedResultsController.fetchedObjects?.count, 2)

        let student = dashBoard.fetchedResultsController.fetchedObjects?[1]
        betterProfessorController.updateStudent(student: student!, name: "Lydia Zhang", email: "Lydia")

        XCTAssertEqual(student?.name, "Lydia Zhang")
        betterProfessorController.delete(student: student!)
    }

}
