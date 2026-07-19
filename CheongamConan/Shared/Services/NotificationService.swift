//
//  NotificationService.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/19/26.
//

import Observation
import UserNotifications

@MainActor
@Observable
final class NotificationService {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorization() async -> Bool {
        let settings = await center.notificationSettings()

        switch settings.authorizationStatus {
        case .notDetermined:
            do {
                return try await center.requestAuthorization(options: [.alert, .sound])
            } catch {
                return false
            }

        case .authorized, .provisional, .ephemeral:
            return true

        case .denied:
            return false

        @unknown default:
            return false
        }
    }

    func notifySubQuest(_ subQuest: SubQuest) async {
        let settings = await center.notificationSettings()

        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "여행을 더 즐겁게 만들어줄 미션"
        content.body = "\(subQuest.title) 사진 찍기"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: subQuest.id.uuidString,
            content: content,
            trigger: nil // 퀘스트 발생하는 순간 알려야하므로 nil
        )

        try? await center.add(request)
    }
}
