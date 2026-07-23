//
//  JourneyRouteStorage.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/24/26.
//

import Foundation
import CoreLocation

struct JourneyRoutePoint: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let recordedAt: Date

    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        recordedAt = location.timestamp
    }

    var location: CLLocation {
        CLLocation(
            latitude: latitude,
            longitude: longitude
        )
    }
}

enum JourneyRouteStorage {
    static let key = "latestJourneyRoute"

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func append(_ locations: [CLLocation]) {
        let savedData =
            UserDefaults.standard.data(forKey: key) ?? Data()

        var savedPoints = decode(savedData)
        var didAppendPoint = false

        let sortedLocations = locations.sorted {
            $0.timestamp < $1.timestamp
        }

        for location in sortedLocations {
            guard
                location.horizontalAccuracy >= 0,
                location.horizontalAccuracy <= 50
            else {
                continue
            }

            if let lastPoint = savedPoints.last {
                guard location.timestamp > lastPoint.recordedAt else {
                    continue
                }

                let distance = location.distance(
                    from: lastPoint.location
                )

                guard distance >= 5 else {
                    continue
                }
            }

            savedPoints.append(
                JourneyRoutePoint(location: location)
            )

            didAppendPoint = true
        }

        guard didAppendPoint else {
            return
        }

        guard let encodedData = encode(savedPoints) else {
            return
        }

        UserDefaults.standard.set(
            encodedData,
            forKey: key
        )
    }

    static func decode(
        _ data: Data
    ) -> [JourneyRoutePoint] {
        guard !data.isEmpty else {
            return []
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        do {
            return try decoder.decode(
                [JourneyRoutePoint].self,
                from: data
            )
        } catch {
            return []
        }
    }

    private static func encode(
        _ points: [JourneyRoutePoint]
    ) -> Data? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970

        do {
            return try encoder.encode(points)
        } catch {
            return nil
        }
    }
}
