//
//  TriggeredSubQuestView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/14/26.
//

import SwiftUI

struct TriggeredSubQuestView: View {
    let subQuest: SubQuest
    let onAuthenticate: () -> Void
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("목적지로 가는 길에")
                    Text(subQuest.title)
                        .font(.largeTitle.bold())
                    Text("찍어보기")
                }
                Button {
                    onAuthenticate()
                } label: {
                    ZStack {
                        Circle()
                            .stroke(.black, lineWidth: 2)
                        Text(subQuest.isCompleted ? "✅" : "📷")
                    }
                    .frame(width: 55, height: 55)
                }
                .disabled(subQuest.isCompleted)
            }
            .padding()
        }
    }
}

#Preview {
    TriggeredSubQuestView(
        subQuest: .movementExample(),
        onAuthenticate: {},
    )
}
