//
//  PermissionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/11/26.
//

import SwiftUI

struct PermissionView: View {
    @Environment(LocationService.self) private var locationService
    @Environment(NotificationService.self) private var notificationService
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var model = PermissionModel()
    
    let onCompleted: () -> Void
    
    var body: some View {
        @Bindable var model = model
        
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 33) {
                Text("시작하기 앞서")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 23) {
                    Text("📍 위치 권한 (필수)")
                        .font(.title3)
                    Text("🔔 알림 권한 (선택)")
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                Task {
                    await model.confirm(
                        using: locationService,
                        notificationService: notificationService,
                        onCompleted: onCompleted
                    )
                }
            } label: {
                Text("확인")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
        .ignoresSafeArea()
        .alert(
            "위치 권한이 필요합니다.",
            isPresented: $model.isLocationSettingsAlertPresented
        ) {
            Button("취소", role: .cancel) {}
            
            Button("설정으로 이동") {
                model.openSettings(using: locationService)
            }
            .keyboardShortcut(.defaultAction)
        } message: {
            Text("현재 위치를 기반으로 서비스를 제공하기 위해 위치 권한이 필요합니다.")
        }
        .onChange(of: locationService.authorizationStatus) { _, _ in
            Task {
                await model.locationAuthorizationDidChange(
                    using: locationService,
                    notificationService: notificationService,
                    onCompleted: onCompleted
                )
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }

            Task {
                await model.appDidBecomeActive(
                    using: locationService,
                    notificationService: notificationService,
                    onCompleted: onCompleted
                )
            }
        }
    }
}

#Preview {
    PermissionView(onCompleted: {})
        .environment(LocationService())
        .environment(NotificationService())
}
