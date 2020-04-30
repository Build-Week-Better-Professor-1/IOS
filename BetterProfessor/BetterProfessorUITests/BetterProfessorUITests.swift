//
//  BetterProfessorUITests.swift
//  BetterProfessorUITests
//
//  Created by Lydia Zhang on 4/29/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import XCTest

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
        
        app.buttons.containing(.staticText, identifier:"Sign In").element.tap()
        sleep(10)
        let baseCell = app.tables.staticTexts["Base"]
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
        
        app.buttons.containing(.staticText, identifier:"Sign In").element.tap()
        sleep(10)
        
        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia")
        
        studentEmail.tap()
        studentEmail.typeText("lydia")
        
        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia"]
        XCTAssert(lydiaCell.exists)
    }
    
    func testDeleteStudent() {
        
        userNameTextField.tap()
        userNameTextField.typeText("Lambda")
        
        passwordTextField.tap()
        passwordTextField.typeText("12345")
        
        app.buttons.containing(.staticText, identifier:"Sign In").element.tap()
        sleep(10)
        
        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia")
        
        studentEmail.tap()
        studentEmail.typeText("lydia")
        
        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia"]
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
        
        app.buttons.containing(.staticText, identifier:"Sign In").element.tap()
        sleep(10)
        
        app.navigationBars["Students"].buttons["Add"].tap()
        studentName.tap()
        studentName.typeText("lydia")
        
        studentEmail.tap()
        studentEmail.typeText("lydia")
        
        app.navigationBars["New Student Info"].buttons["Save"].tap()
        sleep(3)
        let lydiaCell = app.tables.staticTexts["lydia"]
        XCTAssert(lydiaCell.exists)
        sleep(1)
        
//        let app = XCUIApplication()
//        let lydiaStaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["lydia"]/*[[".cells.staticTexts[\"lydia\"]",".staticTexts[\"lydia\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        lydiaStaticText.tap()
//        
//        let studentsButton = app.navigationBars["Student Info"].buttons["Students"]
//        studentsButton.tap()
//        lydiaStaticText.tap()
//        app.textFields["Student Name:"].swipeLeft()
        
    }
}
