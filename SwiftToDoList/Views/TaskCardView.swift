//
//  TitleCardView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/11.
//

import SwiftUI

struct TaskCardView: View {
    var task: Tasks
    @ObservedObject var viewModel: TaskViewModel
    
    var priorityColor: Color {
            switch task.priority {
            case .high: return .red
            case .medium: return .orange
            default: return .green
            }
        }

    var body : some View{
        HStack(spacing:8){
            Toggle("", isOn: Binding(
                get: { task.isCompleted },
                set: { _ in viewModel.toggleCompletion(task: task) }
            ))
            .labelsHidden()
            .frame(alignment: .leading)
            
            VStack(alignment:.leading, spacing:5){
                Text(task.description)
                    .font(.custom("TrebuchetMS", size: 16))
                    .bold()
                Text("Due Date: " + DateFormatter.localizedString(from: task.dueDate, dateStyle: .medium, timeStyle: .none))
                    .font(.custom("TrebuchetMS", size: 13))
                    .bold()
                
            }
            .frame(width: 180, alignment: .leading)
            .padding(.leading,8)
            
            Text(task.priority.rawValue)
                .font(.system(size: 12))
                .foregroundColor(priorityColor)
                .frame(width: 60, height: 24)
                .background(priorityColor.opacity(0.3))
                .cornerRadius(8)
                .padding(.leading, 8)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleTask = Tasks(id: UUID(),description: "Work on methodology the end",dueDate: Date(),priority: .low,reminderEnabled: true,isCompleted: false)
        
        let viewModel = TaskViewModel(repository: TaskRepository())

        TaskCardView(task: sampleTask, viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
