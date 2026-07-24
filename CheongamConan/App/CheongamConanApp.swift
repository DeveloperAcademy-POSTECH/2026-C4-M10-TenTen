//
//  CheongamConanApp.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/10/26.
//

import SwiftUI
import NMapsMap
import SwiftData

@main
struct CheongamConanApp: App {
    @State private var locationService = LocationService()
    @State private var notificationService = NotificationService()
    @State private var missionActivityManager = MissionActivityManager()
    @State private var deepLinkRouter = DeepLinkRouter()
    
    init() {
        NMFAuthManager.shared().ncpKeyId = AppConfig.naverMapKeyID
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(locationService)
                .environment(notificationService)
                .environment(missionActivityManager)
                .environment(deepLinkRouter)
                .task {
                    missionActivityManager.restore()
                }
                .onOpenURL { url in
                    deepLinkRouter.handle(url)
                }
        }
        .modelContainer(
            for: [
                RecommendedPlace.self,
                MissionRecord.self,
                JourneySession.self
            ]
        )
    }
}
