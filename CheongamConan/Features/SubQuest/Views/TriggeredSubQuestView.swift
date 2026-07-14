//
//  TriggeredSubQuestView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/14/26.
//

import SwiftUI

struct TriggeredSubQuestView: View {
    let subQuest: SubQuest
    let onDismiss: () -> Void
    var body: some View {
        NavigationStack {
            HStack(spacing: 30) {
                VStack {
                    Text(subQuest.title)
                        .font(.largeTitle.bold())
                    Text(subQuest.description)
                        .font(.title2)
                }
                Button("나중에 하기") {
                    onDismiss()
                }
            }
            .padding()
        }
    }
}

#Preview {
    TriggeredSubQuestView(
        subQuest: .movementExample(),
        onDismiss: {}
    )
}
