//
//  TodayTasksWidgetTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/12/08.
//

import SwiftUI
import XCTest
@testable import SwiftToDoListWidgetExtension
import AppIntents

final class TodayTasksWidgetTest: XCTestCase {
    private var provider: TodayTasksProvider!
    
    override func setUp() {
        super.setUp()
        provider = TodayTasksProvider()
    }
    
    override func tearDown() {
        provider = TodayTasksProvider()
        super.tearDown()
    }
    
    func test_PriorityRawValues() {
        XCTAssertEqual(Priority.low.rawValue, "Low")
        XCTAssertEqual(Priority.medium.rawValue, "Medium")
        XCTAssertEqual(Priority.high.rawValue, "High")
    }
    
    func test_TasksInitialization() {
        let id = UUID()
        let description = "Test task"
        let dueDate = Date()
        let task = Tasks(id: id, description: description, dueDate: dueDate, priority: .medium, reminderEnabled: true, isCompleted: false)
        
        XCTAssertEqual(task.id, id)
        XCTAssertEqual(task.description, description)
        XCTAssertEqual(task.dueDate, dueDate)
        XCTAssertEqual(task.priority, .medium)
        XCTAssertTrue(task.reminderEnabled)
        XCTAssertFalse(task.isCompleted)
    }
    
    func testTodayTasksEntryInitialization() {
        let date = Date()
        let task = Tasks(
            id: UUID(),
            description: "Task",
            dueDate: date,
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        let entry = TodayTasksEntry(date: date, tasks: [task])
        
        XCTAssertEqual(entry.date, date)
        XCTAssertEqual(entry.tasks.count, 1)
        XCTAssertEqual(entry.tasks[0].description, "Task")
    }
}
