//
//  DSPrimaryButton.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/16/26.
//

import SwiftUI

struct DSPrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DSTypography.B2)
            .foregroundStyle(DSColor.brandWhite)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.x4)
            .background(DSColor.brandPrimary)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: DSRadius.standard
                )
            )
            
    }
}
