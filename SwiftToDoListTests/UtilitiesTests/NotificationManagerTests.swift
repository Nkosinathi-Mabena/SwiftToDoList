//
//  NotificationManagerTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/24.
//

import XCTest
import UserNotifications
import ObjectiveC.runtime
@testable import SwiftToDoList

final class NotificationManagerTests: XCTestCase {

    final class Stub {
        static var requests: [UNNotificationRequest] = []
        static var removedIds: [String] = []
        static func reset() {
            requests.removeAll()
            removedIds.removeAll()
        }
    }

    override class func setUp() {
        super.setUp()
        swizzleAdd()
        swizzleRemovePending()
        swizzleRemoveAll()
    }

    override func setUp() {
        super.setUp()
        Stub.reset()
    }


    func test_scheduleTaskReminder_skipsPastDue_andAddsFuture() {
        let manager = NotificationManager.shared

        let past = Tasks(id: UUID(), description: "Past", dueDate: Date().addingTimeInterval(-3600),
                         priority: .low, reminderEnabled: true, isCompleted: false)
        manager.scheduleTaskReminder(for: past)
        XCTAssertTrue(Stub.requests.isEmpty, "Past-due tasks should be skipped")

        let future = Tasks(id: UUID(), description: "Future", dueDate: Date().addingTimeInterval(3600),
                           priority: .low, reminderEnabled: true, isCompleted: false)
        manager.scheduleTaskReminder(for: future)
        XCTAssertEqual(Stub.requests.count, 1)
        let req = Stub.requests.first
        XCTAssertEqual(req?.identifier, "taskReminder_\(future.id.uuidString)")
        XCTAssertTrue(req?.content.body.contains("Future") ?? false)
    }

    func test_scheduleDailyReminder_usesIdentifier() {
        let manager = NotificationManager.shared
        manager.scheduleDailyReminder()

        XCTAssertEqual(Stub.requests.count, 1)
        XCTAssertEqual(Stub.requests.first?.identifier, "dailyTaskReminder")
    }

    func test_cancelDailyReminder_and_cancelTaskReminder() {
        let manager = NotificationManager.shared
        manager.cancelDailyReminder()
        XCTAssertTrue(Stub.removedIds.contains("dailyTaskReminder"))

        let task = Tasks(id: UUID(), description: "X", dueDate: Date(),
                         priority: .low, reminderEnabled: true, isCompleted: false)
        manager.cancelTaskReminder(for: task)
        XCTAssertTrue(Stub.removedIds.contains("taskReminder_\(task.id.uuidString)"))
    }

    func test_updateDailyReminderContent_callsCancelThenSchedule() {
        let manager = NotificationManager.shared
        manager.updateDailyReminderContent()

        XCTAssertTrue(Stub.removedIds.contains("dailyTaskReminder"))
        XCTAssertEqual(Stub.requests.count, 1)
        XCTAssertEqual(Stub.requests.first?.identifier, "dailyTaskReminder")
    }

    private class func swizzleAdd() {
        let cls = UNUserNotificationCenter.self
        let original = class_getInstanceMethod(cls, #selector(UNUserNotificationCenter.add(_:withCompletionHandler:)))!
        let block: @convention(block) (AnyObject, UNNotificationRequest, ((Error?) -> Void)?) -> Void = { _, request, completion in
            Stub.requests.append(request)
            completion?(nil)
        }
        let imp = imp_implementationWithBlock(block)
        method_setImplementation(original, imp)
    }

    private class func swizzleRemovePending() {
        let cls = UNUserNotificationCenter.self
        let original = class_getInstanceMethod(cls, #selector(UNUserNotificationCenter.removePendingNotificationRequests(withIdentifiers:)))!
        let block: @convention(block) (AnyObject, [String]) -> Void = { _, ids in
            Stub.removedIds.append(contentsOf: ids)
        }
        let imp = imp_implementationWithBlock(block)
        method_setImplementation(original, imp)
    }

    private class func swizzleRemoveAll() {
        let cls = UNUserNotificationCenter.self
        let original = class_getInstanceMethod(cls, #selector(UNUserNotificationCenter.removeAllPendingNotificationRequests))!
        let block: @convention(block) (AnyObject) -> Void = { _ in
            Stub.removedIds.append("ALL")
        }
        let imp = imp_implementationWithBlock(block)
        method_setImplementation(original, imp)
    }
}
