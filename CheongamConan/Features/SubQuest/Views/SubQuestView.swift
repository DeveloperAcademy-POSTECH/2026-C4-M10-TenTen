//
//  SubQuestView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/11/26.
//

import SwiftUI

struct SubQuestView: View {
    @State private var isCameraPresented = false
    @State private var isCompleted = false
    var body: some View {
        NavigationStack {
            VStack {
                content
                Spacer()
                arrivalButton
            }
            // Apple은 카메라 인터페이스는 전체 화면으로 표시하는 것을 권장한다
            .fullScreenCover(isPresented: $isCameraPresented) {
                CameraPicker(isPresented: $isCameraPresented, isCompleted: $isCompleted)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 32) {
            destinationSection
            subQuestSection
        }
    }
    
    private var destinationSection: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("오늘의 목적지")
                .font(.title.bold())
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(maxWidth: .infinity, maxHeight: 150)
            
        }
        .padding()
        .frame(maxHeight: 350)
    }
    
    private var subQuestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("서브 퀘스트")
                .font(.title.bold())
            
            HStack {
                VStack(alignment: .leading) {
                    Text("📷 버튼을 눌러 사진을 촬영해보세요")
                    Text("촬영을 완료하면 버튼이 ✅로 바뀝니다.")
                    Text("취소하면 📷 버튼은 그대로 유지됩니다.")
                    
                }
                .font(.body)
                Spacer()
                
                Button {
                    isCameraPresented = true
                    
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                        Text(isCompleted ? "✅" : "📷")
                    }
                    .frame(width: 55, height: 55)
                }
                .disabled(isCompleted)
            }
        }
        .padding()
    }
    
    private var arrivalButton: some View {
        Button("도착") {
            // 목적지 도착 버튼
        }
    }
}




#Preview {
    SubQuestView()
}
