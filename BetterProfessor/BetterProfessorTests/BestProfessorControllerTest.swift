//
//  BestProfessorControllerTest.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor
//Some of these test needs pre set up object in firebase, if you cannot open my firebase, plase make your own firebase inside the controller and create objects whenever needed
class BestProfessorControllerTest: XCTestCase {

    func testFetchStudent() {
        let betterProfessorController = BetterProfessorController()
        let expectation = self.expectation(description: "Waiting to fetch students")

        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

    }

    func testMakingStudent() {
        let betterProfessorController = BetterProfessorController()


        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lambda")
        sleep(5)

        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

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

        XCTAssertNoThrow(betterProfessorController.delete(student: Student(name: "Lydia", email: "Lydia", professor: "Lambda")))
        
    }

    func testUpdateStudent() {
        let betterProfessorController = BetterProfessorController()

        betterProfessorController.createStudent(name: "Lydia", email: "Lydia", professor: "Lambda")
        sleep(5)

        let expectation = self.expectation(description: "Waiting to fetch students")
        betterProfessorController.fetchStudent { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        XCTAssertNoThrow(betterProfessorController.updateStudent(student: Student(name: "Lydia", email: "Lydia", professor: "Lambda"), name: "Lydia Zhang", email: "Lydia"))
    }

}
