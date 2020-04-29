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
        
        betterProfessorController.fetchStudent() { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(betterProfessorController.studentRep.count, 1)
    }
    
    func testUpdateStudent() {
        let betterProfessorController = BetterProfessorController()
        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lydia")
        sleep(5)
        
        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent() { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(betterProfessorController.studentRep.count, 2)
    }
    
    func testDeleteStudent() {
        let betterProfessorController = BetterProfessorController()
        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lydia")
        sleep(5)
        
        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent() { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(betterProfessorController.studentRep.count, 2)
        
        let dashBoard = DashboardTableViewController()
        let student = dashBoard.fetchedResultsController.fetchedObjects?[1]
        let expectation2 = self.expectation(description: "Waiting to Delete Students")
        betterProfessorController.delete(student: student!) 
    }
}
