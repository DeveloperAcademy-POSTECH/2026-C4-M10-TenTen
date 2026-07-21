//
//  OnboardingView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/11/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isPermissionViewPresented: Bool = false
    @State private var step = 0
    
    let onCompleted: () -> Void

    var body: some View {
        ZStack {
            if isPermissionViewPresented {
                PermissionView(
                    onCompleted: onCompleted
                )
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
            } else {
//                IntroductionView()
//                    .transition(
//                        .move(edge: .top)
//                        .combined(with: .opacity)
//                    )
                if step == 1 {
                    VStack(alignment: .leading) {
                        Text("목적지를 저희가 정해드릴게요")
                            .font(DSTypography.H1)
                            .transition(
                                .move(edge: .trailing)
                                .combined(with: .opacity)
                            )
                            .padding(.top, 130)
                            .padding(.trailing, 20)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        }
                    }
                
                if step == 2 {
                    VStack {
                    Text("가는 길에서 새로운 경험을 즐겨보세요")
                        .font(DSTypography.H1)
                        .transition(
                            .move(edge: .trailing)
                            .combined(with: .opacity)
                        )
                        .padding(.top, 293)
                        .padding(.leading, 20)
                    
                    Spacer()
                    }
                }
                
                if step >= 3 {
                    VStack {
                        Text("목적지가\n바뀌어도 괜찮아요!")
                            .font(DSTypography.H1)
                            .transition(
                                .move(edge: .trailing)
                                .combined(with: .opacity)
                            )
                            .padding(.top, 456)
                            .padding(.leading, 20)
                        
                        Spacer()
                    }
                }
                
                if step == 4 {
                        NavigationStack {
                            VStack {
                                Text("목적지가\n바뀌어도 괜찮아요!")
                                    .font(DSTypography.H1)
                                    .transition(
                                        .move(edge: .top)
                                        .combined(with: .opacity)
                                    )
                                    .padding(.top, 456)
                                    .padding(.leading, 20)
                                
                                Spacer()
                                
                                NavigationLink(destination: PermissionView(
                                    onCompleted: onCompleted
                                )
                                    .navigationBarBackButtonHidden(true), label : {
                                        Text("확인")
                                            .foregroundStyle(.neutralWhite)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 16)
                                            .background(Color.main300)
                                            .cornerRadius(16)
                                    }
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            }
                        }
                    
                    
                }
            }
        }
        .task {
            withAnimation(.easeOut(duration: 1.5)) {
                step = 1
            }
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            withAnimation(.easeOut(duration: 1.5)) {
                step = 2
            }
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            withAnimation(.easeOut(duration: 1.5)) {
                step = 3
            }
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            withAnimation(.easeOut(duration: 1.5)) {
                step = 4
            }
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            guard !Task.isCancelled else { return }
            
//            withAnimation(.easeOut(duration: 1.5)) {
//                isPermissionViewPresented = true
//            }
        }
    }
}

#Preview {
    OnboardingView(onCompleted: {})
        .environment(LocationService())
        .environment(NotificationService())
}
