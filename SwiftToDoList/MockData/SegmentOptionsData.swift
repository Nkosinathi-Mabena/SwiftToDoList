//
//  CardType.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/08/27.
//


//
//  SegmentOptionsData.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/10.
//

enum CardType: String, CaseIterable {
    case tasks = "Tasks"
    case priority = "priority"
    case overdue = "Over Due"
    case today = "Today"
    
    var options: [String]  {
        switch self {
        case .tasks:
            return ["Incompleted", "Completed"]
        case .priority:
            return ["Low", "Medium", "High"]
        case .overdue:
            return ["Over Due"]
        case .today:
            return ["Today's Tasks"]
        }
    }
}