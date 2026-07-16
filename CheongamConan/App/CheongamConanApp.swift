//
//  CheongamConanApp.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/10/26.
//

import SwiftUI

@main
struct CheongamConanApp: App {
    @State private var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(locationService)
        }
    }
}
