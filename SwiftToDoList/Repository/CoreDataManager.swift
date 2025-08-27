//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/13.
//

import CoreData
import Foundation

final class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "TaskEntity")
        persistentContainer.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Core data store failed: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext(){
        if context.hasChanges{
            do {
                try context.save()
            } catch{
                print("Failed to save context: \(error.localizedDescription)")
            }
        }
    }
}
