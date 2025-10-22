//
//  NotificationSettingsView.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/01/27.
//

import SwiftUI

struct NotificationSettingsView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var dailyReminderEnabled = false
    @State private var showingPermissionAlert = false
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Notification Settings")
                        .font(.title2)
                        .bold()
                    
                    Toggle("Daily Task Reminder", isOn: $dailyReminderEnabled)
                        .onChange(of: dailyReminderEnabled) { enabled in
                            if enabled {
                                viewModel.scheduleDailyReminder()
                            } else {
                                viewModel.cancelDailyReminder()
                            }
                        }
                    
                    Text("Get reminded daily at 7:00 AM about your tasks due today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Tasks with Reminders")
                            .font(.headline)
                        
                        let tasksWithReminders = viewModel.getTasksDueTodayWithReminders()
                        
                        if tasksWithReminders.isEmpty {
                            Text("No tasks due today with reminders enabled")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(tasksWithReminders) { task in
                                HStack {
                                    Circle()
                                        .fill(task.priority == .high ? .red : task.priority == .medium ? .orange : .green)
                                        .frame(width: 8, height: 8)
                                    
                                    Text(task.description)
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .onAppear {
                checkNotificationPermission()
            }
            .alert("Notification Permission Required", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable notifications in Settings to receive daily reminders about your tasks.")
            }
        }
    }
    
    private func checkNotificationPermission() {
        Task {
            let status = await NotificationManager.shared.checkNotificationPermission()
            await MainActor.run {
                permissionStatus = status
                if status == .denied {
                    showingPermissionAlert = true
                }
            }
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView(viewModel: DIContainer.shared.resolveTaskViewModel())
    }
}
