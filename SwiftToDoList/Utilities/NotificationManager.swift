//
//  NotificationManager.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/27.
//

import Foundation
import UserNotifications
import CoreData

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let taskRepository: TaskRepositoryProtocol
    
    private init() {
        self.taskRepository = DIContainer.shared.resolve(TaskRepositoryProtocol.self)!
    }
    
    // Have to get permission first
    
    func requestNotificationPermission() async -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            print("Failed to request notification permission: \(error)")
            return false
        }
    }
    
    func checkNotificationPermission() async -> UNAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus
    }
    
    
    func scheduleDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyTaskReminder"])
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Daily Task Reminder"
        content.sound = .default
        
        
        let tasksDueToday = getTasksDueTodayWithReminders()
        let taskCount = tasksDueToday.count
        
        if taskCount > 0 {
            content.body = "You have \(taskCount) task\(taskCount == 1 ? "" : "s") due today!"
        } else {
            content.body = "You have no tasks due today. Great job staying on top of things!"
        }
        
        //This will Create trigger for 7:00 AM daily
        var dateComponents = DateComponents()
        dateComponents.hour = 16
        dateComponents.minute = 46
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "dailyTaskReminder",
            content: content,
            trigger: trigger
        )
        
        // Schedule notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule daily reminder: \(error)")
            } else {
                print("Daily reminder scheduled successfully")
            }
        }
    }
    
    func cancelDailyReminder() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["dailyTaskReminder"])
        print("Daily reminder cancelled")
    }
    
    
    func scheduleTaskReminder(for task: Tasks) {
        guard task.reminderEnabled else { return }
        
        // Only schedule notifications for future dates
        let now = Date()
        guard task.dueDate > now else {
            print("Task '\(task.description)' is due in the past, skipping notification")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Don't forget: \(task.description)"
        content.sound = .default
        content.badge = 1
        
        let triggerDate = task.dueDate
        let timeInterval = triggerDate.timeIntervalSinceNow
        
        guard timeInterval > 0 else {
            print("Task '\(task.description)' has invalid time interval, skipping notification")
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "taskReminder_\(task.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Failed to schedule task reminder: \(error)")
            } else {
                print("Task reminder scheduled for: \(task.description)")
            }
        }
    }
    
    func cancelTaskReminder(for task: Tasks) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["taskReminder_\(task.id.uuidString)"])
    }
    
    
    private func getTasksDueTodayWithReminders() -> [Tasks] {
        let allTasks = taskRepository.fetchTasks()
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return allTasks.filter { task in
            task.reminderEnabled &&
            !task.isCompleted &&
            task.dueDate >= today &&
            task.dueDate < tomorrow
        }
    }
    
    func updateDailyReminderContent() {
        cancelDailyReminder()
        
        scheduleDailyReminder()
    }
    
    
    func getAllPendingNotifications() async -> [UNNotificationRequest] {
        return await notificationCenter.pendingNotificationRequests()
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("All notifications cancelled")
    }
}
