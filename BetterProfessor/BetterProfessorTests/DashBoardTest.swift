//
//  DashBoardTest.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor

class DashBoardTest: XCTestCase {

    func testSignUp() {
        let login = APIController()
        let professor = Professor(username: "Lambda", password: "12345")

        let expectation = self.expectation(description: "Waiting for Sign In")
        login.signUp(with: professor) { error in
            if let error = error {
                NSLog("Error when signing up: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

    func testSignIn() {
        let login = APIController()
        let professor = Professor(username: "Lambda", password: "12345")

        let expectation = self.expectation(description: "Waiting for Sign In")
        login.signIn(with: professor) { error in
            if let error = error {
                NSLog("Error when signing in: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(login.bearer)
    }

    func testCheckCell() {

        let dash = DashboardTableViewController()

        //i previously made 2 students
        let numberOfRows = dash.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRows, 2)
        let baseName = dash.fetchedResultsController.fetchedObjects?[0].name
        XCTAssertEqual(baseName, "112")

    }

}
