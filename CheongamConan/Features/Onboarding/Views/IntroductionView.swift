//
//  IntroductionView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/11/26.
//

import SwiftUI

struct IntroductionView: View {
    var body: some View {
        Text(
            """
            목적지를 정하는 과정이
            복잡하고 부담스러워서
            망설이지 않으셨나요?
            """
        )
        .font(.title)
        .fontWeight(.semibold)
        .lineSpacing(6)
        .padding(.leading, 9)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    IntroductionView()
}
