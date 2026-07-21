//
//  CameraPicker.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/12/26.
//

import SwiftUI
import UIKit

/// UIKit의 카메라 화면을 SwiftUI에 연결하고,
/// 촬영 성공과 취소 이벤트만 상위 View로 전달한다
struct CameraPicker: UIViewControllerRepresentable {
    let onCapture: (UIImage) -> Void
    let onCancel: () -> Void
    let onFailure: (Error) -> Void

    init(
        onCapture: @escaping (UIImage) -> Void,
        onCancel: @escaping () -> Void,
        onFailure: @escaping (Error) -> Void = { _ in }
    ) {
        self.onCapture = onCapture
        self.onCancel = onCancel
        self.onFailure = onFailure
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) { }

    // 카메라의 촬영 및 취소 이벤트를 SwiftUI 상태로 전달
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [
                UIImagePickerController.InfoKey: Any
            ]
        ) {
            // 촬영 성공
            guard let image = info[.originalImage] as? UIImage else {
                parent.onFailure(
                    CameraPickerError.imageNotFound
                )
                return
            }
            parent.onCapture(image)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 촬영 취소
            parent.onCancel()
        }
    }
}

enum CameraPickerError: Error {
    case imageNotFound
}
