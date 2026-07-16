//
//  AreaPickerModel.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import CoreLocation
import Observation

@MainActor
@Observable
final class AreaPickerModel {
    private(set) var polygons: [MapPolygon] = []
    private(set) var isLoading: Bool = false

    var errorMessage: String?

    private let areaService: VWorldAreaService
    private var lastRequestedLocation: CLLocation?

    init() {
        areaService = VWorldAreaService()
    }

    init(areaService: VWorldAreaService) {
        self.areaService = areaService
    }

    func loadAreas(
        around coordinate: CLLocationCoordinate2D
    ) async {
        let requestedLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        if let lastRequestedLocation,
           requestedLocation.distance(
            from: lastRequestedLocation
           ) < 1_000 {
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            polygons = try await areaService.fetchAreas(
                around: coordinate,
                radius: 10_000
            )

            lastRequestedLocation = requestedLocation
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
