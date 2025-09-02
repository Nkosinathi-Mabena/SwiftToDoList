//
//  AddTaskSheetView.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/08/27.
//

import SwiftUI

struct AddTaskSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    var taskToEdit: Tasks?
    
    @State private var taskDescription: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskPriority: Priority = .low
    @State private var reminderEnabled: Bool = false
    @State private var showDeleteAlert = false    
    
    init(viewModel: TaskViewModel, taskToEdit: Tasks? = nil) {
        self.viewModel = viewModel // to remember the instance used by the parent view
        
        self.taskToEdit = taskToEdit
        
        if let task = taskToEdit {//populate state properties
            _taskDescription = State(initialValue: task.description)
            _taskDate = State(initialValue: task.dueDate)
            _taskPriority = State(initialValue: task.priority)
            _reminderEnabled = State(initialValue: task.reminderEnabled)
        } else {
            _taskDescription = State(initialValue: "")
            _taskDate = State(initialValue: Date())
            _taskPriority = State(initialValue: .low)
            _reminderEnabled = State(initialValue: false)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Task")
                .font(.title)
                .bold()
            
            TextField("Description", text: $taskDescription)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            DatePicker("Select Due Date", selection: $taskDate, displayedComponents: .date)
                .padding(.horizontal)
            
            Picker("Priority", selection: $taskPriority) {
                Text("Low").tag(Priority.low)
                Text("Medium").tag(Priority.medium)
                Text("High").tag(Priority.high)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            Toggle("Set Reminder", isOn: $reminderEnabled)
            
            HStack(spacing: 60) {
                if taskToEdit != nil {
                    Button("Update Task") {
                        let updatedTask = Tasks(id: taskToEdit!.id,description: taskDescription,dueDate: taskDate,priority: taskPriority,reminderEnabled: reminderEnabled,
                            isCompleted: taskToEdit!.isCompleted
                        )
                        viewModel.updateTask(task: updatedTask)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Delete Task") {
                        showDeleteAlert = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                    .alert("Are you sure you want to delete this task?", isPresented: $showDeleteAlert) {
                        Button("Delete", role: .destructive) {
                            if let task = taskToEdit {
                                viewModel.deleteTask(task: task)
                                dismiss()
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                } else {
                    Button("Save Task") {
                        viewModel.addTask(description: taskDescription,dueDate: taskDate,priority: taskPriority,reminderEnabled: reminderEnabled
                        )
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
                    
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}
