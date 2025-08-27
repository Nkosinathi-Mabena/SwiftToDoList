//
//  TaskRepository.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/13.
//

import CoreData
import Foundation

protocol TaskRepositoryProtocol { // basically an interface
    func addTask(_ task: Tasks)
    func fetchTasks () -> [Tasks]
    func updateTask(_ task: Tasks)
    func deleteTask(_ task: Tasks)
}

final class TaskRepository: TaskRepositoryProtocol {
    private let manager = CoreDataManager.shared //access core data stack
    
    func addTask(_ task: Tasks){
        let entity = TaskEntity(context: manager.context)
        entity.id = task.id
        entity.taskDescription = task.description
        entity.taskDate = task.dueDate
        entity.taskPriority = task.priority.rawValue
        entity.reminderEnabled = task.reminderEnabled
        entity.taskCompleted = task.isCompleted
        manager.saveContext()
    }
    
    func fetchTasks() -> [Tasks] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let entities = try manager.context.fetch(request)
            return entities.map { entity in
                Tasks(
                    id: entity.id ?? UUID(),
                    description: entity.taskDescription ?? "",
                    dueDate: entity.taskDate ?? Date(),
                    priority: Priority(rawValue: entity.taskPriority ?? "Low") ?? .low,
                    reminderEnabled: entity.reminderEnabled,
                    isCompleted: entity.taskCompleted
                )
            }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func updateTask(_ task: Tasks){
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@" , task.id as CVarArg)  //predicate is the core datas way of filtering, example we fetching task WHERE id =
        if let entity = try? manager.context.fetch(request).first{
            entity.taskDescription = task.description
            entity.taskDate = task.dueDate
            entity.taskPriority = task.priority.rawValue
            entity.reminderEnabled = task.reminderEnabled
            entity.taskCompleted = task.isCompleted // in addTask & updateTask
            manager.saveContext()
        }
    }
    
    func deleteTask(_ task: Tasks){
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        if let entity = try? manager.context.fetch(request).first{
            manager.context.delete(entity)
            manager.saveContext()
        }
    }
}
