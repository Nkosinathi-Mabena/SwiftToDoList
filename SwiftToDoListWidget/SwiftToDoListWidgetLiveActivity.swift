//
//  SwiftToDoListWidgetLiveActivity.swift
//  SwiftToDoListWidget
//
//  Created by Nathi Mabena on 2025/09/28.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SwiftToDoListWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SwiftToDoListWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SwiftToDoListWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SwiftToDoListWidgetAttributes {
    fileprivate static var preview: SwiftToDoListWidgetAttributes {
        SwiftToDoListWidgetAttributes(name: "World")
    }
}

extension SwiftToDoListWidgetAttributes.ContentState {
    fileprivate static var smiley: SwiftToDoListWidgetAttributes.ContentState {
        SwiftToDoListWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SwiftToDoListWidgetAttributes.ContentState {
         SwiftToDoListWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SwiftToDoListWidgetAttributes.preview) {
   SwiftToDoListWidgetLiveActivity()
} contentStates: {
    SwiftToDoListWidgetAttributes.ContentState.smiley
    SwiftToDoListWidgetAttributes.ContentState.starEyes
}
