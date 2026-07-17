//
//  NaverMapConfiguration.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/16/26.
//

import NMapsMap

struct NaverMapConfiguration {
    var styleID: String?
    
    var showsLocationButton: Bool
    var showsZoomControls: Bool
    
    var isLogoInteractionEnabled: Bool
    var isZoomGestureEnabled: Bool
    
    static let `default` = NaverMapConfiguration(
        styleID: AppConfig.naverMapStyleID,
        showsLocationButton: false,
        showsZoomControls: false,
        isLogoInteractionEnabled: false,
        isZoomGestureEnabled: true
    )
    
    func apply(to naverMapView: NMFNaverMapView) {
        let mapView = naverMapView.mapView
        
        naverMapView.showLocationButton = showsLocationButton
        
        naverMapView.showZoomControls = showsZoomControls
        
        mapView.logoInteractionEnabled = isLogoInteractionEnabled
        
        mapView.isZoomGestureEnabled = isZoomGestureEnabled
        
        guard let styleID else {
            return
        }
        
        mapView.setCustomStyleId(styleID, loadHandler: {}, failHandler: { _ in })
    }
}
