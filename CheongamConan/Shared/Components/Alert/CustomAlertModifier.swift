//
//  CustomAlertModifier.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import SwiftUI

private struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    let title: String
    let content: String?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let primaryAction: () -> Void
    let secondaryAction: (() -> Void)?
    
    func body(content baseContent: Content) -> some View {
        baseContent
            .overlay {
                if isPresented {
                    CustomAlert(
                        title: title,
                        content: content,
                        primaryButtonTitle: primaryButtonTitle,
                        secondaryButtonTitle: secondaryButtonTitle,
                        primaryAction: {
                            isPresented = false
                            primaryAction()
                        },
                        secondaryAction: secondaryAction.map { action in
                            {
                                isPresented = false
                                action()
                            }
                        }
                    )
                    .transition(.opacity)
                    .zIndex(999)
                }
            }
    }
}

extension View {
    func customAlert(
        isPresented: Binding<Bool>,
        title: String,
        content: String? = nil,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            CustomAlertModifier(
                isPresented: isPresented,
                title: title,
                content: content,
                primaryButtonTitle: primaryButtonTitle,
                secondaryButtonTitle: secondaryButtonTitle,
                primaryAction: primaryAction,
                secondaryAction: secondaryAction
            )
        )
    }
}
