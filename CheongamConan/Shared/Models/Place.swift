//
//  Place.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/15/26.
//

import Foundation

struct Place: Identifiable, Hashable, Decodable {
    let name: String
    let category: String
    let address: String
    let roadAddress: String
    let latitude: Double
    let longitude: Double
    let link: URL?

    var id: String {
        "\(name)_\(latitude)_\(longitude)"
    }

    private enum CodingKeys: String, CodingKey {
        case title
        case category
        case address
        case roadAddress
        case link
        case mapX = "mapx"
        case mapY = "mapy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(
            keyedBy: CodingKeys.self
        )

        let title = try container.decode(
            String.self,
            forKey: .title
        )

        let mapX = try container.decode(
            String.self,
            forKey: .mapX
        )

        let mapY = try container.decode(
            String.self,
            forKey: .mapY
        )

        let link = try container.decode(
            String.self,
            forKey: .link
        )

        guard let rawLongitude = Double(mapX),
              let rawLatitude = Double(mapY) else {
            throw DecodingError.dataCorruptedError(
                forKey: .mapX,
                in: container,
                debugDescription: "장소 좌표를 변환할 수 없습니다."
            )
        }

        self.name = title

        self.category = try container.decode(
            String.self,
            forKey: .category
        )

        self.address = try container.decode(
            String.self,
            forKey: .address
        )

        self.roadAddress = try container.decode(
            String.self,
            forKey: .roadAddress
        )

        self.longitude = rawLongitude / 10_000_000
        self.latitude = rawLatitude / 10_000_000
        self.link = link.isEmpty ? nil : URL(string: link)
    }
}
