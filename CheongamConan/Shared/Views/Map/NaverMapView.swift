//
//  NaverMapView.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import SwiftUI
import NMapsMap

struct NaverMapView<Coordinator: NSObject>: UIViewRepresentable {
    let configuration: NaverMapConfiguration
    let coordinatorBuilder: () -> Coordinator
    
    let onMake: (NMFNaverMapView, Coordinator) -> Void
    let onUpdate: (NMFNaverMapView, Coordinator) -> Void
    
    init(
        configuration: NaverMapConfiguration = .default,
        coordinatorBuilder: @escaping () -> Coordinator,
        onMake: @escaping (NMFNaverMapView, Coordinator) -> Void = { _, _ in },
        onUpdate: @escaping (NMFNaverMapView, Coordinator) -> Void = { _, _ in }
    ) {
        self.configuration = configuration
        self.coordinatorBuilder = coordinatorBuilder
        self.onMake = onMake
        self.onUpdate = onUpdate
    }
    
    func makeCoordinator() -> Coordinator {
        coordinatorBuilder()
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let naverMapView = NMFNaverMapView(frame: .zero)
        
        configuration.apply(to: naverMapView)
        onMake(naverMapView, context.coordinator)
        
        return naverMapView
    }
    
    func updateUIView(_ naverMapView: NMFNaverMapView, context: Context) {
        configuration.apply(to: naverMapView)
        onUpdate(naverMapView, context.coordinator)
    }
}
