//
//  MissionActivityManager.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/21/26.
//

import ActivityKit
import Foundation
import Observation


@MainActor
@Observable
final class MissionActivityManager {
    @ObservationIgnored
    private var activity: Activity<MissionActivityAttributes>?
    
    func start(
        destinationID: UUID
    ) async throws {
        // Live Activity 중복 생성 방지
        if let existingActivity = Activity<MissionActivityAttributes>
            .activities
            .first(where: {
                $0.attributes.destinationID == destinationID
            }) {
            activity = existingActivity
            return
        }
        
        for existingActivity in Activity<MissionActivityAttributes>.activities {
            await existingActivity.end(
                nil,
                dismissalPolicy: .immediate
            )
        }
        
        let attributes = MissionActivityAttributes(destinationID: destinationID)
        
        let content = ActivityContent(
            state: MissionActivityAttributes.ContentState(
                missionID: nil,
                missionTitle: nil,
                status: .locked
            ),
            staleDate: nil
        )
        
        activity = try Activity.request(
            attributes: attributes,
            content: content,
            pushType: nil // APNs 구현 범위 제외
        )
    }
    
    func showMission(
        missionID: UUID,
        title: String
    ) async {
        guard let activity = currentActivity() else {
            return
        }
        
        let content = ActivityContent(
            state: MissionActivityAttributes.ContentState(
                missionID: missionID,
                missionTitle: title,
                status: .available
            ),
            staleDate: nil
        )
        await activity.update(content)
    }
    
    func completeMission(missionID: UUID) async {
        guard let activity = currentActivity() else {
            return
        }
        
        let currentState = activity.content.state
        
        guard currentState.missionID == missionID else {
            return
        }
        
        let content = ActivityContent(
            state: MissionActivityAttributes.ContentState(
                missionID: currentState.missionID,
                missionTitle: currentState.missionTitle,
                status: .completed
            ),
            staleDate: nil
        )
        await activity.update(content)
    }
    
    func end() async {
        for existingActivity in Activity<MissionActivityAttributes>.activities {
            await existingActivity.end(
                nil,
                dismissalPolicy: .immediate
            )
        }
        self.activity = nil
    }
    
    func restore() {
        activity = Activity<MissionActivityAttributes>.activities.first
    }
    
    private func currentActivity() -> Activity<MissionActivityAttributes>? {
        if activity == nil {
            restore()
        }
        return activity
    }
}
