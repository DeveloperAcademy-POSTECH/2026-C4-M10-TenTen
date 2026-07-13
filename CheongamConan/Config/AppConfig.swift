//
//  AppConfig.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/13/26.
//

import Foundation

enum AppConfig {
    static let naverMapKeyID: String = value(for: "NMFClientId")
    static let vWorldAPIKey: String = value(for: "VWorldAPIKey")
    static let naverMapStyleID: String = value(for: "NaverMapStyleID")

    private static func value<T>(for key: String) -> T {
        guard let value = Bundle.main.object(
            forInfoDictionaryKey: key
        ) as? T else {
            fatalError("\(key) 설정값을 찾을 수 없습니다.")
        }

        return value
    }
}
