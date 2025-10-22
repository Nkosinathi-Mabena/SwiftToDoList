//
//  WidgetCoreDataManager.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/28.
//

import CoreData
import Foundation

final class WidgetCoreDataManager {
    static let shared = WidgetCoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        // Create a programmatic Core Data model since main .xcdatamodeld may not be accessible to widget
        let model = Self.createTaskEntityModel()
        persistentContainer = NSPersistentContainer(name: "TaskEntity", managedObjectModel: model)
        
        // Configure the persistent store with error handling
        if let appGroupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.NathiDev.SwiftToDoList") {
            let storeURL = appGroupContainerURL.appendingPathComponent("TaskEntity.sqlite")
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true
            persistentContainer.persistentStoreDescriptions = [storeDescription]
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Widget CoreData store failed to load: \(error.localizedDescription)")
                // Don't crash the widget if CoreData fails - we'll use sample data instead
            }
        }
        
        // Configure the view context
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private static func createTaskEntityModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // Create TaskEntity
        let taskEntity = NSEntityDescription()
        taskEntity.name = "TaskEntity"
        taskEntity.managedObjectClassName = "TaskEntity"
        
        // Create attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = true
        
        let taskDescriptionAttribute = NSAttributeDescription()
        taskDescriptionAttribute.name = "taskDescription"
        taskDescriptionAttribute.attributeType = .stringAttributeType
        taskDescriptionAttribute.isOptional = true
        
        let taskDateAttribute = NSAttributeDescription()
        taskDateAttribute.name = "taskDate"
        taskDateAttribute.attributeType = .dateAttributeType
        taskDateAttribute.isOptional = true
        
        let taskPriorityAttribute = NSAttributeDescription()
        taskPriorityAttribute.name = "taskPriority"
        taskPriorityAttribute.attributeType = .stringAttributeType
        taskPriorityAttribute.isOptional = true
        
        let reminderEnabledAttribute = NSAttributeDescription()
        reminderEnabledAttribute.name = "reminderEnabled"
        reminderEnabledAttribute.attributeType = .booleanAttributeType
        reminderEnabledAttribute.isOptional = true
        
        let taskCompletedAttribute = NSAttributeDescription()
        taskCompletedAttribute.name = "taskCompleted"
        taskCompletedAttribute.attributeType = .booleanAttributeType
        taskCompletedAttribute.isOptional = true
        
        // Add attributes to entity
        taskEntity.properties = [
            idAttribute,
            taskDescriptionAttribute,
            taskDateAttribute,
            taskPriorityAttribute,
            reminderEnabledAttribute,
            taskCompletedAttribute
        ]
        
        // Add entity to model
        model.entities = [taskEntity]
        
        return model
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func fetchTodaysTasks() -> [Tasks] {
        // Check if CoreData is properly initialized
        guard persistentContainer.persistentStoreCoordinator.persistentStores.count > 0 else {
            print("Widget: CoreData not properly initialized, returning sample data")
            return []
        }
        
        do {
            // Use NSManagedObject directly since TaskEntity class may not be available in widget target
            let request = NSFetchRequest<NSManagedObject>(entityName: "TaskEntity")
            
            // Filter for today's tasks that are not completed
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: Date())
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            
            request.predicate = NSPredicate(format: "taskDate >= %@ AND taskDate < %@ AND taskCompleted == NO",
                                          startOfDay as NSDate, endOfDay as NSDate)
            
            // Sort by priority (high first) and then by due time
            request.sortDescriptors = [
                NSSortDescriptor(key: "taskPriority", ascending: false),
                NSSortDescriptor(key: "taskDate", ascending: true)
            ]
            
            let entities = try context.fetch(request)
            
            let tasks = entities.compactMap { entity -> Tasks? in
                guard let id = entity.value(forKey: "id") as? UUID,
                      let description = entity.value(forKey: "taskDescription") as? String,
                      let dueDate = entity.value(forKey: "taskDate") as? Date,
                      let priorityString = entity.value(forKey: "taskPriority") as? String,
                      let reminderEnabled = entity.value(forKey: "reminderEnabled") as? Bool,
                      let isCompleted = entity.value(forKey: "taskCompleted") as? Bool else {
                    print("Widget: Skipping task with missing required fields")
                    return nil
                }
                
                return Tasks(
                    id: id,
                    description: description,
                    dueDate: dueDate,
                    priority: Priority(rawValue: priorityString) ?? .low,
                    reminderEnabled: reminderEnabled,
                    isCompleted: isCompleted
                )
            }
            
            print("Widget: Successfully fetched \(tasks.count) tasks for today")
            return tasks
        } catch {
            print("Widget: Error fetching today's tasks: \(error.localizedDescription)")
            return []
        }
    }
}
