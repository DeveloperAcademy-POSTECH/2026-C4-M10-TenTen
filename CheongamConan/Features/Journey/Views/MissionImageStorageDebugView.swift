//
//  MissionImageStorageDebugView.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//
import SwiftUI
import UIKit

#if DEBUG
struct MissionImageStorageDebugView: View {
    private let imageStorageService =
        MissionImageStorageService()

    @State private var isCameraPresented = false
    @State private var missionID = UUID()
    @State private var savedFileName: String?
    @State private var loadedImage: UIImage?
    @State private var statusMessage = "테스트 준비 완료"

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                imagePreview

                Text(statusMessage)
                    .multilineTextAlignment(.center)

                if let savedFileName {
                    Text(savedFileName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }

                Button("1. 카메라로 촬영 및 저장") {
                    isCameraPresented = true
                }
                .buttonStyle(.borderedProminent)

                Button("2. 저장된 이미지 불러오기") {
                    loadSavedImage()
                }
                .buttonStyle(.bordered)
                .disabled(savedFileName == nil)

                Button("3. 저장된 이미지 삭제") {
                    deleteSavedImage()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .disabled(savedFileName == nil)
            }
            .padding()
        }
        .navigationTitle("미션 사진 테스트")
        .fullScreenCover(
            isPresented: $isCameraPresented
        ) {
            cameraPicker
        }
    }

    private var cameraPicker: some View {
        CameraPicker(
            onCapture: { image in
                isCameraPresented = false
                saveCapturedImage(image)
            },
            onCancel: {
                isCameraPresented = false
                statusMessage = "촬영 취소"
            },
            onFailure: { error in
                isCameraPresented = false
                statusMessage = "촬영 실패: \(error)"
            }
        )
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var imagePreview: some View {
        if let loadedImage {
            Image(uiImage: loadedImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 400)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.2))
                .frame(height: 300)
                .overlay {
                    Text("불러온 이미지 없음")
                        .foregroundStyle(.secondary)
                }
        }
    }

    private func saveCapturedImage(
        _ image: UIImage
    ) {
        do {
            // 반복 테스트 시 이전 파일 정리
            if let savedFileName {
                try? imageStorageService.delete(
                    fileName: savedFileName
                )
            }

            let fileName = try imageStorageService.save(
                image,
                missionID: missionID
            )

            savedFileName = fileName
            loadedImage = nil
            statusMessage = """
            촬영 이미지 저장 성공
            불러오기 버튼으로 파일을 확인하세요.
            """
        } catch {
            statusMessage = "이미지 저장 실패: \(error)"
        }
    }

    private func loadSavedImage() {
        guard let savedFileName else {
            return
        }

        do {
            loadedImage = try imageStorageService.load(
                fileName: savedFileName
            )
            statusMessage = "촬영 이미지 불러오기 성공"
        } catch {
            statusMessage = "이미지 불러오기 실패: \(error)"
        }
    }

    private func deleteSavedImage() {
        guard let savedFileName else {
            return
        }

        do {
            try imageStorageService.delete(
                fileName: savedFileName
            )

            self.savedFileName = nil
            loadedImage = nil
            missionID = UUID()
            statusMessage = "이미지 삭제 성공"
        } catch {
            statusMessage = "이미지 삭제 실패: \(error)"
        }
    }
}
#endif
