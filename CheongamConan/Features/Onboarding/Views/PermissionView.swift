//
//  PermissionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/11/26.
//

import SwiftUI

struct PermissionView: View {
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 33) {
                Text("시작하기 앞서")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 23) {
                    Text("📍 위치 권한 (필수)")
                        .font(.title3)
                    
                    Text("🔔 알림 권한 (필수)")
                        .font(.title3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Button {
                print("버튼 누름")
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
    }
}

#Preview {
    PermissionView()
}
