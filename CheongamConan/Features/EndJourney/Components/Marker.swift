//
//  Marker.swift
//  CheongamConan
//
//  Created by 정홍섭 on 7/23/26.
//

import UIKit

extension UIImage {
    static func circleMarker(
        number: String,
        size: CGSize = CGSize(width: 20, height: 20),
        fillColor: UIColor,
        textColor: UIColor = .white
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            context.cgContext.setFillColor(fillColor.cgColor)
            context.cgContext.fillEllipse(in: rect)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: DSTypography.markerUIFont,
                .foregroundColor: textColor
            ]
            
            let attributedString = NSAttributedString(
                string: number,
                attributes: attributes
            )
            
            let textSize = attributedString.size()
            
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            attributedString.draw(in: textRect)
        }
    }
}
