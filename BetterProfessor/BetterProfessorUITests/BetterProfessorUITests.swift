//
//  BetterProfessorUITests.swift
//  BetterProfessorUITests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest
@testable import BetterProfessor
//Some of these test needs pre set up object in firebase, if you cannot open my firebase, plase make your own firebase inside the controller and create objects whenever needed
class BetterProfessorUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launch()
    }

    private var userNameTextField: XCUIElement {
        return app.textFields["Username:"]
    }
    private var passwordTextField: XCUIElement {
        return app.secureTextFields["Password:"]
    }
    private var loginButton: XCUIElement {
        return app.buttons["LoginButton"]
    }
    private var addButton1: XCUIElement {
        return app.buttons["DashboardTableViewController.AddButton"]
    }

    func testLogin() {

        userNameTextField.tap()
        userNameTextField.typeText("Lambda")

        passwordTextField.tap()
        passwordTextField.typeText("12345")

        app.buttons.containing(.staticText, identifier: "Sign In").element.tap()
        sleep(10)
        let baseCell = app.tables.staticTexts["112"]
        XCTAssert(baseCell.exists)
    }

    private var studentName: XCUIElement {
        return app.textFields["Student Name:"]
    }
    private var studentEmail: XCUIElement {
        return app.textFields["Student Email:"]
    }
    func testAddStudent() {
        userNameTextField.tap()
        userNameTextField.typeText("Lambda")

        passwordTextField.tap()
        passwordTextField.typeText("12345")

        app.buttons.containing(.staticText, identifier: "Sign In").element.tap()
        sleep(10)

        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia1")

        studentEmail.tap()
        studentEmail.typeText("lydia")

        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia1"]
        XCTAssert(lydiaCell.exists)
    }

    func testDeleteStudent() {

        userNameTextField.tap()
        userNameTextField.typeText("Lambda")

        passwordTextField.tap()
        passwordTextField.typeText("12345")

        app.buttons.containing(.staticText, identifier: "Sign In").element.tap()
        sleep(10)

        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia2")

        studentEmail.tap()
        studentEmail.typeText("lydia")

        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia2"]
        XCTAssert(lydiaCell.exists)
        sleep(1)
        lydiaCell.swipeLeft()
        app.tables/*@START_MENU_TOKEN@*/.buttons["trailing0"]/*[[".cells",".buttons[\"Delete\"]",".buttons[\"trailing0\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        sleep(2)
        XCTAssertFalse(lydiaCell.exists)

    }

    func testUpdateStudent() {

        userNameTextField.tap()
        userNameTextField.typeText("Lambda")

        passwordTextField.tap()
        passwordTextField.typeText("12345")

        app.buttons.containing(.staticText, identifier: "Sign In").element.tap()
        sleep(10)

        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia3")

        studentEmail.tap()
        studentEmail.typeText("lydia")

        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia3"]
        XCTAssert(lydiaCell.exists)
        sleep(1)

        lydiaCell.tap()
        app.buttons["Edit Student Info"].tap()
        studentName.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: 5)
        
        studentName.typeText(deleteString)
        studentName.typeText("lydia4")

        app.buttons["Save Student Info"].tap()
        app.navigationBars["Student Info"].buttons["Students"].tap()
        sleep(3)
        let newLydiaCell = app.tables.staticTexts["lydia4"]
        XCTAssert(newLydiaCell.exists)

    }
    
    func testTaskCell() {
        
        userNameTextField.tap()
        userNameTextField.typeText("Lambda")

        passwordTextField.tap()
        passwordTextField.typeText("12345")

        app.buttons.containing(.staticText, identifier: "Sign In").element.tap()
        sleep(10)
        
        let baseCell = app.tables.staticTexts["114"]
        baseCell.tap()
        sleep(2)
        
        
        XCTAssertNotNil(app.tables.staticTexts["Test"])
    }
}
