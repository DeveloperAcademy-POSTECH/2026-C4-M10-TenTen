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

    init(
        name: String,
        category: String,
        address: String,
        roadAddress: String,
        latitude: Double,
        longitude: Double,
        link: URL?
    ) {
        self.name = name
        self.category = category
        self.address = address
        self.roadAddress = roadAddress
        self.latitude = latitude
        self.longitude = longitude
        self.link = link
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

#if DEBUG
extension Place {
    static let preview = Place(
        name: "바르벳",
        category: "카페",
        address: "경북 포항시 남구 효자동 225-2",
        roadAddress: "경북 포항시 남구 효자동 225-2",
        latitude: 36.009731,
        longitude: 129.333273,
        link: nil
    )
}
#endif
