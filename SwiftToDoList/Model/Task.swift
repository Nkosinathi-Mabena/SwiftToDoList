//
//  File.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import Foundation //test

enum Priority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Tasks: Identifiable{
    let id: UUID
    var description: String
    var dueDate: Date
    var priority: Priority
    var reminderEnabled: Bool
    var isCompleted: Bool
}
