//
//  CameraPicker.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/12/26.
//


import SwiftUI
import UIKit


// UIKit의 시스템 카메라를 SwiftUI에서 표시하기 위한 어댑터
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var isCompleted: Bool
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    // 카메라의 촬영 및 취소 이벤트를 SwiftUI 상태로 전달
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [
                UIImagePickerController.InfoKey : Any
            ]
        ) {
            // 촬영 성공
            parent.isCompleted = true
            parent.isPresented = false
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // 촬영 취소
            parent.isPresented = false
        }
    }
}
