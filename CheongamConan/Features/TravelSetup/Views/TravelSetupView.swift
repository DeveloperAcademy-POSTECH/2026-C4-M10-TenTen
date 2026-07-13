//
//  TravelSetupView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import SwiftUI

struct TravelSetupView: View {
    @State private var model = TravelSetupModel()
    
    var body: some View {
        AreaPickerView()
            .environment(model)
    }
}

#Preview {
    TravelSetupView()
        .environment(LocationService())
}
