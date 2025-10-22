//
//  SwiftToDoListWidgetBundle.swift
//  SwiftToDoListWidget
//
//  Created by Nathi Mabena on 2025/09/28.
//

import WidgetKit
import SwiftUI

@main
struct SwiftToDoListWidgetBundle: WidgetBundle {
    var body: some Widget {
        SwiftToDoListWidget()
//        SwiftToDoListWidgetControl()
//        SwiftToDoListWidgetLiveActivity()
        TodayTasksWidget()
    }
}
