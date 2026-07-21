//
//  MissionImageStorageService.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/20/26.
//

import Foundation
import UIKit

actor MissionImageStorageService {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    // 폴더 저장 위치 정의
    private func missionImageDirectoryURL() throws -> URL {
        guard let applicationSupportURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            throw MissionImageStorageError.applicationSupportUnavailable
        }
        
        return applicationSupportURL
            .appendingPathComponent(
                "MissionImages",
                isDirectory: true
            )
    }
    
    // 이미지를 처음 저장할 때 폴더 생성
    private func createDirectoryIfNedded(
        at directoryURL: URL
    ) throws {
        try fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )
    }

    func save(
        _ image: UIImage,
        missionID: UUID
    ) throws -> String {
        let directoryURL = try missionImageDirectoryURL()
        try createDirectoryIfNedded(at: directoryURL)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8)
        else {
            throw MissionImageStorageError.imageEncodingFailed
        }
        
        let fileName = "\(missionID.uuidString)-\(UUID().uuidString).jpg"
        let fileURL = directoryURL.appendingPathComponent(fileName)
        try imageData.write(
            to: fileURL,
            options: .atomic
        )

        return fileName
    }
    
    // 저장된 이미지 불러오기
    func load(fileName: String) throws -> UIImage {
        let directoryURL = try missionImageDirectoryURL()
        let fileURL = directoryURL.appendingPathComponent(fileName)
        
        guard fileManager.fileExists(atPath: fileURL.path)
        else { throw MissionImageStorageError.fileNotFound }
        
        let imageData = try Data(
            contentsOf: fileURL
        )
        
        guard let image = UIImage(data: imageData) else {
            throw MissionImageStorageError.invalidImageData
        }
        
        return image
    }
    
    func delete(fileName: String) throws {
        let directoryURL = try missionImageDirectoryURL()
        let fileURL = directoryURL.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path)
        else { return }
        
        try fileManager.removeItem(at: fileURL)
    }
    
    enum MissionImageStorageError: Error {
        case applicationSupportUnavailable
        case imageEncodingFailed
        case fileNotFound
        case invalidImageData
    }
}
