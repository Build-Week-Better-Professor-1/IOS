//
//  DashBoardTest.swift
//  BetterProfessorTests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor
//Some of these test needs pre set up object in firebase, if you cannot open my firebase, plase make your own firebase inside the controller and create objects whenever needed
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
        login.signIn(with: professor) { error,result  in
            if let error = error {
                NSLog("Error when signing in: \(error)")
            }
            XCTAssertNoThrow(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        XCTAssertNotNil(login.bearer)
    }

    func testBearer() {

        let login = APIController()
        let professor = Professor(username: "Lambda", password: "12345")

        let expectation = self.expectation(description: "Waiting for Sign In")
        login.signIn(with: professor) { result, error  in
            if let error = error {
                NSLog("Error when signing in: \(error)")
            }
            XCTAssertNoThrow(error)

            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        

    }

}
