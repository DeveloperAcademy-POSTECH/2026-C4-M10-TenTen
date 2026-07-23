//
//  ShareSheet.swift
//  CheongamConan
//
//  Created by Jess on 7/23/26.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension UIApplication {
    // y 지점 아래(버튼 영역)를 제외하고 화면을 캡처하기 위해 crop 로직 추가
    func captureCurrentScreen(excludingBelow y: CGFloat) -> UIImage? {
            guard let window = UIApplication.shared.windows.first(where: \.isKeyWindow)
            else { return nil }
            
            let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
            let fullImage = renderer.image { _ in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
            
            guard let cgImage = fullImage.cgImage else { return fullImage }
            
            let scale = fullImage.scale
            let cropRect = CGRect(
                x: 0,
                y: 0,
                width: CGFloat(cgImage.width),
                height: min(y * scale, CGFloat(cgImage.height))
            )
            
            guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return fullImage }
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: fullImage.imageOrientation)
        }
}


// (홈으로 가기) (공유하기) 버튼 잘라서 캡쳐할 때
// 기기별 화면 크기, 방문한 장소 수에 따라 버튼 위치가 달라질 수 있어서 추가
struct ButtonsTopYKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}
