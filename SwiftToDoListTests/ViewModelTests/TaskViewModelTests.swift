//
//  TaskViewModelTests.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/21.
//

import XCTest
@testable import SwiftToDoList

final class TaskViewModelTests: XCTestCase {
    private var viewModel: TaskViewModel!
    private var repository: MockTaskRepository!
    
    override func setUp() {
        super.setUp()
        repository = MockTaskRepository()
        viewModel = TaskViewModel(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_AddTask() {
        viewModel.addTask(
            description: "Test Task",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false
        )
        
        XCTAssertEqual(repository.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.description, "Test Task")
    }
    
    func test_FetchTasks() {
        viewModel.addTask(
            description: "This is a task",
            dueDate: Date(),
            priority: .medium,
            reminderEnabled: true
        )
        
        viewModel.fetchTasks()
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.description, "This is a task")
    }
    
    func test_UpdateTask() {
        var task = Tasks(
            id: UUID(),
            description: "TaSk TaSk",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        repository.addTask(task)
        viewModel.fetchTasks()
        
        task.description = "Updated task"
        task.reminderEnabled = true
        viewModel.updateTask(task: task)
        
        XCTAssertEqual(repository.tasks.first?.description, "Updated task")
        XCTAssertEqual(viewModel.tasks.first?.description, "Updated task")
        XCTAssertEqual(viewModel.tasks.first?.reminderEnabled, true)
    }
    
    func test_DeleteTask() {
        let task = Tasks(
            id: UUID(),
            description: "TaSk TaSk",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        repository.addTask(task)
        viewModel.fetchTasks()
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        
        viewModel.deleteTask(task: task)
        
        XCTAssertEqual(viewModel.tasks.count, 0)
    }
    
    func test_ToggleCompletion() {
        let task = Tasks(
            id: UUID(),
            description: "TaSk TaSk",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        
        repository.addTask(task)
        
        viewModel.fetchTasks()
        viewModel.toggleCompletion(task: task)
        
        XCTAssertTrue(viewModel.tasks.first!.isCompleted)
    }
    
    func test_filteredTasks() {
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        let task1 = Tasks(
            id: UUID(),
            description: "This task is not important",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        
        let task2 = Tasks(
            id: UUID(),
            description: "This task is semi important",
            dueDate: yesterday,
            priority: .medium,
            reminderEnabled: true,
            isCompleted: false
        )
        
        let task3 = Tasks(
            id: UUID(),
            description: "This task is very important",
            dueDate: Date(),
            priority: .high,
            reminderEnabled: true,
            isCompleted: false
        )
        
        var task4 = Tasks(
            id: UUID(),
            description: "This task is overdue",
            dueDate: tomorrow,
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        
        repository.addTask(task1)
        repository.addTask(task2)
        repository.addTask(task3)
        repository.addTask(task4)
        
        viewModel.fetchTasks()
        
        task4.isCompleted = true
        viewModel.fetchTasks()
        
        viewModel.updateTask(task: task4)
        
        viewModel.tasks = [task1, task2, task3, task4]
        
        
        XCTAssertEqual(viewModel.tasks.count, 4)
        XCTAssertEqual(viewModel.tasks.first?.priority, .low)
        XCTAssertEqual(viewModel.tasks[3].isCompleted, true)
        
    }
    
    func test_filteredTasks_nilCardReturnsEmpty() {
        let result = viewModel.filteredTasks(selectedCard: nil, selectedSegment: nil)
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_taskCount_andFilteredLogic() {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let todayTask = Tasks(id: UUID(), description: "Today", dueDate: today.addingTimeInterval(3600), priority: .high, reminderEnabled: true, isCompleted: false)
        let overdueTask = Tasks(id: UUID(), description: "Overdue", dueDate: yesterday, priority: .medium, reminderEnabled: true, isCompleted: false)
        let completedTask = Tasks(id: UUID(), description: "Done", dueDate: tomorrow, priority: .low, reminderEnabled: false, isCompleted: true)
        
        repository.addTask(todayTask)
        repository.addTask(overdueTask)
        repository.addTask(completedTask)
        viewModel.fetchTasks()
        
        XCTAssertEqual(viewModel.taskCount(cardCount: .tasks), 3)
        XCTAssertEqual(viewModel.taskCount(cardCount: .priority), 3)
        XCTAssertEqual(viewModel.taskCount(cardCount: .today), 1)
        XCTAssertEqual(viewModel.taskCount(cardCount: .overdue), 1)
        
        let overdueFiltered = viewModel.filteredTasks(selectedCard: .overdue, selectedSegment: nil)
        XCTAssertEqual(overdueFiltered.count, 1)
        XCTAssertEqual(overdueFiltered.first?.description, "Overdue")
        
        let todayFiltered = viewModel.filteredTasks(selectedCard: .today, selectedSegment: nil)
        XCTAssertEqual(todayFiltered.count, 1)
        XCTAssertEqual(todayFiltered.first?.description, "Today")
        
        let completedFiltered = viewModel.filteredTasks(selectedCard: .tasks, selectedSegment: "Completed")
        XCTAssertEqual(completedFiltered.count, 1)
        XCTAssertEqual(completedFiltered.first?.description, "Done")
        
        let priorityFiltered = viewModel.filteredTasks(selectedCard: .priority, selectedSegment: Priority.high.rawValue)
        XCTAssertEqual(priorityFiltered.count, 1)
        XCTAssertEqual(priorityFiltered.first?.priority, .high)
    }
    
    func test_getTasksDueTodayWithReminders_filtersCorrectly() {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        let dueTodayReminder = Tasks(id: UUID(), description: "Today-reminder", dueDate: today.addingTimeInterval(3600), priority: .low, reminderEnabled: true, isCompleted: false)
        let dueTodayNoReminder = Tasks(id: UUID(), description: "No reminder", dueDate: today.addingTimeInterval(7200), priority: .low, reminderEnabled: false, isCompleted: false)
        let dueTomorrowReminder = Tasks(id: UUID(), description: "Tomorrow", dueDate: tomorrow.addingTimeInterval(3600), priority: .low, reminderEnabled: true, isCompleted: false)
        let completedToday = Tasks(id: UUID(), description: "Completed", dueDate: today.addingTimeInterval(3600), priority: .low, reminderEnabled: true, isCompleted: true)
        
        repository.addTask(dueTodayReminder)
        repository.addTask(dueTodayNoReminder)
        repository.addTask(dueTomorrowReminder)
        repository.addTask(completedToday)
        viewModel.fetchTasks()
        
        let tasks = viewModel.getTasksDueTodayWithReminders()
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.description, "Today-reminder")
    }
}

final class MockTaskRepository: TaskRepositoryProtocol {
    var tasks: [Tasks] = []
    
    func addTask(_ task: Tasks) {
        tasks.append(task)
    }
    
    func fetchTasks() -> [Tasks] {
        return tasks
    }
    
    func updateTask(_ task: Tasks) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: Tasks) {
        tasks.removeAll { $0.id == task.id }
    }
}
