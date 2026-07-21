//
//  MissionWidgetLiveActivity.swift
//  MissionWidget
//
//  Created by Dayoon Lee on 7/21/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MissionWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MissionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MissionWidgetAttributes.self) { context in
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

extension MissionWidgetAttributes {
    fileprivate static var preview: MissionWidgetAttributes {
        MissionWidgetAttributes(name: "World")
    }
}

extension MissionWidgetAttributes.ContentState {
    fileprivate static var smiley: MissionWidgetAttributes.ContentState {
        MissionWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MissionWidgetAttributes.ContentState {
         MissionWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MissionWidgetAttributes.preview) {
   MissionWidgetLiveActivity()
} contentStates: {
    MissionWidgetAttributes.ContentState.smiley
    MissionWidgetAttributes.ContentState.starEyes
}
