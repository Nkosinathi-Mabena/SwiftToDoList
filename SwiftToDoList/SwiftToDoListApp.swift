//
//  SwiftToDoListApp.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/08/27.
//

import SwiftUI

@main
struct SwiftToDoListApp: App {
    @StateObject private var taskViewModel = DIContainer.shared.resolveTaskViewModel()
    
    var body: some Scene {
        WindowGroup{
            TabBarView()
                .preferredColorScheme(.dark)
                .onAppear {
                    setupNotifications()
                }
        }
    }
    
    private func setupNotifications() {
        Task {
            let permissionGranted = await taskViewModel.requestNotificationPermission()
            if permissionGranted {
                taskViewModel.scheduleDailyReminder()
            }
        }
    }
}
