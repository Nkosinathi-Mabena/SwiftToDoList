//
//  AddTaskSheetView.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/28.
//

import XCTest
@testable import SwiftToDoList

final class AddTaskSheetViewTest: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait

        app = XCUIApplication()

        app.terminate()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    func descriptionField() -> XCUIElement {
        let field = app.textFields
            .matching(NSPredicate(format: "placeholderValue == %@", "Description"))
            .firstMatch
        return field
    }

    func createTask(description: String) {
        app.buttons["plus"].tap()

        XCTAssertTrue(app.staticTexts["Add Task"].waitForExistence(timeout: 3))

        let field = descriptionField()
        XCTAssertTrue(field.waitForExistence(timeout: 3))

        field.tap()
        field.typeText(description)

        let saveButton = app.buttons["Save Task"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        saveButton.tap()

        XCTAssertTrue(app.staticTexts[description].waitForExistence(timeout: 3))
    }

    func test_AddTask() throws {
        createTask(description: "Task A")
        XCTAssertTrue(app.staticTexts["Task A"].exists)
    }

    func test_UpdateTask() throws {
        createTask(description: "Old Task")

        let cell = app.staticTexts["Old Task"]
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.tap()

        let descField = descriptionField()
        XCTAssertTrue(descField.waitForExistence(timeout: 3))
        descField.clearAndEnterText(text: "Updated Task")

        let highButton = app.buttons["High"]
        XCTAssertTrue(highButton.waitForExistence(timeout: 3))
        highButton.tap()

        let toggle = app.switches["Set Reminder"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 3))
        toggle.tap()

        let updateButton = app.buttons["Update Task"]
        XCTAssertTrue(updateButton.waitForExistence(timeout: 3))
        updateButton.tap()

        XCTAssertTrue(app.staticTexts["Updated Task"].waitForExistence(timeout: 3))
    }

    func test_DeleteTask() throws {
        createTask(description: "DeleteMe")

        let cell = app.staticTexts["DeleteMe"]
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.tap()

        let deleteSheetButton = app.buttons["Delete Task"]
        XCTAssertTrue(deleteSheetButton.waitForExistence(timeout: 3))
        deleteSheetButton.tap()

        XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 3))
        app.buttons["Delete"].tap()

        XCTAssertFalse(app.staticTexts["DeleteMe"].exists)
    }

    func test_CancelDeleteTask() throws {
        createTask(description: "Try Delete Me")

        let cell = app.staticTexts["Try Delete Me"]
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.tap()

        app.buttons["Delete Task"].tap()
        XCTAssertTrue(app.buttons["Cancel"].waitForExistence(timeout: 3))
        app.buttons["Cancel"].tap()

        XCTAssertTrue(app.staticTexts["Try Delete Me"].exists)
    }
}

extension XCUIElement {
    func clearAndEnterText(text: String) {
        tap()

        if let value = self.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue,
                                      count: value.count)
            typeText(deleteString)
        }

        typeText(text)
    }
}
