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
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 112) {
                Text("여행 전에 앱 사용을 위해\n필요한 권한을 허용해주세요")
                    .font(DSTypography.H4)
                
                VStack(alignment: .leading, spacing: 52) {
                    PermissionList(icon: "location.circle.fill", title: "위치 (필수)", content: "우리 앱은 위치를 기반으로 더 나은 목적지를\n추천해 드리고자 해요.")
                    
                    PermissionList(icon:"bell.fill", title: "알람 (필수)", content: "우리 앱은 여행의 몰입을 중간중간 알람으로\n서브 퀘스트같은 컨텐츠 요소를 알람으로\n보내드려요.")
                }
            }
            
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
            }
            .buttonStyle(DSButtonStyle(backgroundColor: .main300, foregroundColor: .neutralWhite))
        }
        .frame(maxWidth: .infinity)
        .navigationBarBackButtonHidden()
        .padding(.horizontal, DSSpacing.contentHorizontal)
        .padding(.bottom, DSSpacing.spacing20)
        .padding(.top, 130)
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

private struct PermissionList: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.main800)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(DSTypography.B2)
                    .padding(.trailing, 40)
                    .foregroundStyle(Color.grey700)
                
                Text(content)
                    .font(DSTypography.C2)
                    .foregroundStyle(Color.grey700)
            }
        }
    }
}

#Preview {
    PermissionView(onCompleted: {})
        .environment(LocationService())
        .environment(NotificationService())
}
