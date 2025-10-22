//
//  TaskViewModel.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/14.
//

import Foundation

final class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Tasks] = [] //used to update UI when tasks are changed
    
    private let repository: TaskRepositoryProtocol
    private let notificationManager = NotificationManager.shared
    
    init(repository: TaskRepositoryProtocol){
        self.repository = repository
        fetchTasks()
    }
    
    func addTask(description: String, dueDate: Date, priority: Priority,reminderEnabled: Bool){
        let newTask = Tasks(id: UUID(), description: description, dueDate: dueDate, priority: priority, reminderEnabled: reminderEnabled, isCompleted: false)
        repository.addTask(newTask)
        fetchTasks()
        
        // Schedule notification if reminder is enabled
        if reminderEnabled {
            notificationManager.scheduleTaskReminder(for: newTask)
        }
        
        // Update daily reminder content
        notificationManager.updateDailyReminderContent()
    }
    
    func fetchTasks(){
        tasks = repository.fetchTasks()
    }
    
    func updateTask(task: Tasks){
        // Cancel existing notification if it exists
        notificationManager.cancelTaskReminder(for: task)
        
        repository.updateTask(task)
        fetchTasks()
        
        // Schedule new notification if reminder is enabled
        if task.reminderEnabled {
            notificationManager.scheduleTaskReminder(for: task)
        }
        
        // Update daily reminder content
        notificationManager.updateDailyReminderContent()
    }
    
    func deleteTask(task:Tasks){
        // Cancel notification for deleted task
        notificationManager.cancelTaskReminder(for: task)
        
        repository.deleteTask(task)
        fetchTasks()
        
        // Update daily reminder content
        notificationManager.updateDailyReminderContent()
    }
    
    func toggleCompletion(task: Tasks) {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        updateTask(task: updatedTask)
    }
    
    func filteredTasks(selectedCard: CardType?, selectedSegment: String?) -> [Tasks] {
        guard let selectedCard = selectedCard else { return [] }
        
        switch selectedCard {
        case .tasks:
            return tasks.filter { $0.isCompleted == (selectedSegment == "Completed") }
        case .priority:
            return tasks.filter { $0.priority.rawValue == selectedSegment }
        case .overdue:
            return tasks.filter { !$0.isCompleted && $0.dueDate < Calendar.current.startOfDay(for: Date()) }
        case .today:
            return tasks.filter { Calendar.current.isDateInToday($0.dueDate) }
        }
    }

    func taskCount(cardCount: CardType) -> Int {
        switch cardCount {
        case .tasks, .priority:
            return tasks.count
        case .today:
            return tasks.filter { Calendar.current.isDateInToday($0.dueDate) }.count
        case .overdue:
            return tasks.filter {
                !$0.isCompleted && $0.dueDate < Calendar.current.startOfDay(for: Date())
            }.count
        }
    }
    
    // MARK: - Notification Management
    
    func requestNotificationPermission() async -> Bool {
        return await notificationManager.requestNotificationPermission()
    }
    
    func scheduleDailyReminder() {
        notificationManager.scheduleDailyReminder()
    }
    
    func cancelDailyReminder() {
        notificationManager.cancelDailyReminder()
    }
    
    func getTasksDueTodayWithReminders() -> [Tasks] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return tasks.filter { task in
            task.reminderEnabled &&
            !task.isCompleted &&
            task.dueDate >= today &&
            task.dueDate < tomorrow
        }
    }
}
