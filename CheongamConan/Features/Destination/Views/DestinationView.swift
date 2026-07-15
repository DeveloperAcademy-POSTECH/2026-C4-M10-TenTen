//
//  DestinationView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/14/26.
//

import SwiftUI

struct DestinationView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("바르벳")
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("경북 포항시 남구 효자동 225-2")
            
            Spacer()
            
            Button{
                // 서브 퀘스트 화면으로 이동 구현
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 44))
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    DestinationView()
}
