//
//  TodayTaskWidget.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/28.
//

import WidgetKit
import SwiftUI
import CoreData
import Foundation

enum Priority: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct Tasks: Identifiable {
    let id: UUID
    var description: String
    var dueDate: Date
    var priority: Priority
    var reminderEnabled: Bool
    var isCompleted: Bool
}

struct TodayTasksWidget: Widget {
    let kind: String = "TodayTasksWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayTasksProvider()) { entry in
            TodayTasksWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Tasks")
        .description("View your tasks for today")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct TodayTasksProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayTasksEntry {
        TodayTasksEntry(date: Date(), tasks: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayTasksEntry) -> ()) {
        // For snapshot, use sample data to ensure it's always available
        let entry = TodayTasksEntry(date: Date(), tasks: getSampleTasks())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodayTasksEntry>) -> ()) {
        let currentDate = Date()
        
        // Always try to get real tasks, but fallback to sample data if needed
        let tasks = getTodaysTasks()
        let entry = TodayTasksEntry(date: currentDate, tasks: tasks)
        
        // Calculate next update time - refresh every hour
        let nextUpdateDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate) ?? 
                           Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        
        let timeline = Timeline<TodayTasksEntry>(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    private func calculateNextUpdateDate(currentDate: Date, tasks: [Tasks]) -> Date {
        let calendar = Calendar.current
        
        // If we have tasks, refresh more frequently
        if !tasks.isEmpty {
            // Refresh every 30 minutes if we have tasks
            return calendar.date(byAdding: .minute, value: 30, to: currentDate) ?? 
                   calendar.date(byAdding: .hour, value: 1, to: currentDate)!
        }
        
        // If no tasks, refresh every 2 hours
        return calendar.date(byAdding: .hour, value: 2, to: currentDate)!
    }
    
    private func getTodaysTasks() -> [Tasks] {
        
        print("Widget: TESTING MODE - Using sample data only")
        return getSampleTasks()
        // Always try to fetch from CoreData first
        /*let coreDataTasks = WidgetCoreDataManager.shared.fetchTodaysTasks()
        
        // If we have real data, use it
        if !coreDataTasks.isEmpty {
            print("Widget: Using \(coreDataTasks.count) real tasks from CoreData")
            return coreDataTasks
        }
        
        // Fallback to sample data if CoreData fails or returns empty
        print("Widget: No real tasks found, using sample data")
        return getSampleTasks()
         */
    }
    
    private func getSampleTasks() -> [Tasks] {
        return [
            Tasks(
                id: UUID(),
                description: "Sample task for today",
                dueDate: Date(),
                priority: .high,
                reminderEnabled: true,
                isCompleted: false
            ),
            Tasks(
                id: UUID(),
                description: "Another task",
                dueDate: Date(),
                priority: .medium,
                reminderEnabled: false,
                isCompleted: false
            )
        ]
    }
}

struct TodayTasksEntry: TimelineEntry {
    let date: Date
    let tasks: [Tasks]
}

struct TodayTasksWidgetEntryView : View {
    var entry: TodayTasksEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Tasks")
                .font(.headline)
                .foregroundColor(.primary)
            
            if entry.tasks.isEmpty {
                Text("No tasks for today!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(Array(entry.tasks.prefix(5))) { task in
                    HStack {
                        Circle()
                            .fill(priorityColor(for: task.priority))
                            .frame(width: 8, height: 8)
                        
                        Text(task.description)
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                            .bold()
                        
                        Spacer()
                        
                        Text(task.priority.rawValue)
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(priorityColor(for: task.priority).opacity(0.3))
                            )
                    }
                }
                
                if entry.tasks.count > 5 {
                    Text("+\(entry.tasks.count - 5) more")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            Image("wood")
                .aspectRatio(contentMode: .fill)
        )
        .containerBackground(.clear, for: .widget)
    }
    
    private func priorityColor(for priority: Priority) -> Color {
        switch priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}

#Preview(as: .systemMedium) {
    TodayTasksWidget()
} timeline: {
    TodayTasksEntry(date: .now, tasks: [
        Tasks(id: UUID(), description: "Complete Research Methodology", dueDate: Date(), priority: .high, reminderEnabled: true, isCompleted: false),
        Tasks(id: UUID(), description: "Do monthly report for school", dueDate: Date(), priority: .medium, reminderEnabled: false, isCompleted: false),
        Tasks(id: UUID(), description: "Go to the mall", dueDate: Date(), priority: .low, reminderEnabled: true, isCompleted: false)
    ])
    TodayTasksEntry(date: .now, tasks: [])
}

