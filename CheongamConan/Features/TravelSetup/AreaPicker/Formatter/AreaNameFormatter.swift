//
//  AreaNameFormatter.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/21/26.
//

import Foundation

enum AreaNameFormatter {
    static func format(_ fullName: String) -> String {
        let components = fullName
            .split(separator: " ")
            .map(String.init)
        
        guard
            let first = components.first,
            let last = components.last
        else {
            return fullName
        }
        
        if first.hasSuffix("특별시")
            || first.hasSuffix("광역시")
            || first.hasSuffix("특별자치시") {
            return "\(shortenedRegionName(first)) \(last)"
        }
        
        if let cityOrCounty = components.dropFirst().first(
            where: {
                $0.hasSuffix("시") || $0.hasSuffix("군")
            }
        ) {
            return "\(String(cityOrCounty.dropLast())) \(last)"
        }
        
        return fullName
    }
    
    private static func shortenedRegionName(_ name: String) -> String {
        let suffixes = [
            "특별자치시",
            "특별시",
            "광역시"
        ]
        
        for suffix in suffixes where name.hasSuffix(suffix) {
            return String(name.dropLast(suffix.count))
        }
        
        return name
    }
}
