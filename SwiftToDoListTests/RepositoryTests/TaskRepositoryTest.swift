//
//  TaskRepositoryTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/20.
//

import XCTest
import CoreData
@testable import SwiftToDoList

extension CoreDataManager  {
    private static var testContext: NSManagedObjectContext?
    
    static func setTestContext(_ context: NSManagedObjectContext) {
        testContext = context
    }
    
    var testAwareContext: NSManagedObjectContext {
        CoreDataManager.testContext ?? self.context
    }
}

final class TaskRepositoryTest: XCTestCase {
    
    override func setUp() {
        super.setUp()

        let manager = CoreDataManager.shared
        let container = manager.persistentContainer

        for store in container.persistentStoreCoordinator.persistentStores {
            try? container.persistentStoreCoordinator.remove(store)
        }

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        manager.context.reset()
    }

    override func tearDown() {
        super.tearDown()
        
        let manager = CoreDataManager.shared
        let context = manager.context
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        if let tasks = try? context.fetch(fetchRequest) {
            for task in tasks {
                context.delete(task)
            }
        }
        try? context.save()
        context.reset()
    }
    
    func test_AddTask() {
        let taskRepository = TaskRepository()
        
        let task = Tasks(
            id: UUID(),
            description: "Test Task",
            dueDate: Date(),
            priority: .high,
            reminderEnabled: true,
            isCompleted: false
        )
        
        taskRepository.addTask(task)
        let tasks = taskRepository.fetchTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.description, "Test Task")
    }
    
    func test_AddMultipleTasks() {
        let taskRepository = TaskRepository()
        let task0 = Tasks (
            id: UUID(),
            description: "Test task 0",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        
        let task1 = Tasks (
            id: UUID(),
            description: "Test task 1",
            dueDate: Date(),
            priority: .medium,
            reminderEnabled: true,
            isCompleted: true
        )
        
        let task2 = Tasks (
            id: UUID(),
            description: "Test task 2",
            dueDate: Date(),
            priority: .high,
            reminderEnabled: true,
            isCompleted: false
        )
        
        taskRepository.addTask(task0)
        taskRepository.addTask(task1)
        taskRepository.addTask(task2)
        
        let tasks = taskRepository.fetchTasks()
        XCTAssertEqual(tasks.count, 3)
        
        let fetchTask0 = tasks.first { $0.id == task0.id}!
        XCTAssertEqual(fetchTask0.description, "Test task 0")
        XCTAssertEqual(fetchTask0.priority, .low)
        XCTAssertFalse(fetchTask0.reminderEnabled)
        
        let fetchTask1 = tasks.first { $0.id == task1.id}!
        XCTAssertEqual(fetchTask1.isCompleted, true)
    }
    
    func test_UpdateTask() {
        let taskRepository = TaskRepository()
        
        var task = Tasks(
            id: UUID(),
            description: "Test task 1",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        taskRepository.addTask(task)
        
        task.description = "Task Test ONE"
        task.isCompleted = true
        taskRepository.updateTask(task)
        
        let tasks = taskRepository.fetchTasks()
        
        XCTAssertEqual(tasks.first?.description, "Task Test ONE")
        XCTAssertEqual(tasks.first?.isCompleted, true)
    }
    
    func test_updateNonExistentTask_doesNothing() {
        let repo = TaskRepository()
        let fakeTask = Tasks(
            id: UUID(),
            description: "Fake Task test",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: false,
            isCompleted: false
        )
        
        XCTAssertNoThrow(repo.updateTask(fakeTask))
    }

    
    
    func test_fetchTask() {
        let taskRepository = TaskRepository()
        
        let task = Tasks(
            id: UUID(),
            description: "Test task 0",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        taskRepository.addTask(task)
        
        let task1 = Tasks(
            id: UUID(),
            description: "Test task 1",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        taskRepository.addTask(task1)
        
        let tasks = taskRepository.fetchTasks()
        
        XCTAssertEqual(tasks.count, 2)
        XCTAssertEqual(tasks.map {$0.description}.sorted(), ["Test task 0", "Test task 1"])
    }
    
    func test_FetchEmptyTask() {
        let taskRepository = TaskRepository()
        let tasks = taskRepository.fetchTasks()
        
        XCTAssertTrue(tasks.isEmpty)
    }
    
    func test_deleteTask() {
        let taskRepository = TaskRepository()
        let task = Tasks(
            id: UUID(),
            description: "Test task 0",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        taskRepository.addTask(task)
        
        let task1 = Tasks(
            id: UUID(),
            description: "Test task 1",
            dueDate: Date(),
            priority: .low,
            reminderEnabled: true,
            isCompleted: false
        )
        taskRepository.addTask(task1)
        
        var tasks = taskRepository.fetchTasks()
        
        XCTAssertEqual(tasks.count, 2)
        
        taskRepository.deleteTask(task)
        tasks = taskRepository.fetchTasks()
        
        XCTAssertEqual(tasks.count, 1)
        XCTAssertFalse(tasks.contains(where: {$0.id == task.id}))
    }
    
    func test_taskFieldMapping() {
        let repo = TaskRepository()
        
        let dueDate = Date()
        let task = Tasks(
            id: UUID(),
            description: "Test mapping",
            dueDate: dueDate,
            priority: .high,
            reminderEnabled: true,
            isCompleted: false
        )
        
        repo.addTask(task)
        
        let fetchedTasks = repo.fetchTasks()
        XCTAssertEqual(fetchedTasks.count, 1)
        
        let fetchedTask = fetchedTasks.first!
        
        XCTAssertEqual(fetchedTask.id, task.id)
        XCTAssertEqual(fetchedTask.description, task.description)
        XCTAssertEqual(fetchedTask.dueDate.timeIntervalSince1970, task.dueDate.timeIntervalSince1970, accuracy: 0.1)
        XCTAssertEqual(fetchedTask.priority, task.priority)
        XCTAssertEqual(fetchedTask.reminderEnabled, task.reminderEnabled)
        XCTAssertEqual(fetchedTask.isCompleted, task.isCompleted)
    }

}
