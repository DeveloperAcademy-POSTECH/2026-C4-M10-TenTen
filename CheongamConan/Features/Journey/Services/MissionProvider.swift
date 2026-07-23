//
//  MissionProvider.swift
//  CheongamConan
//
//  Created by Codex on 7/24/26.
//

import Foundation

/// 번들에 포함된 미션 목록을 읽고 실행할 미션을 제공한다.
struct MissionProvider {
    private static let supportedVersion = 1

    private let missions: [MissionDefinition]

    init(
        bundle: Bundle = .main,
        resourceName: String = "Missions"
    ) throws {
        guard let url = bundle.url(
            forResource: resourceName,
            withExtension: "json"
        ) else {
            throw MissionProviderError.resourceNotFound(resourceName)
        }

        let data = try Data(contentsOf: url)
        let catalog = try JSONDecoder().decode(
            MissionCatalog.self,
            from: data
        )

        guard catalog.version == Self.supportedVersion else {
            throw MissionProviderError.unsupportedVersion(catalog.version)
        }
        guard !catalog.missions.isEmpty else {
            throw MissionProviderError.emptyCatalog
        }
        guard catalog.missions.allSatisfy({
            !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }) else {
            throw MissionProviderError.emptyTitle
        }

        missions = catalog.missions
    }

    /// JSON의 정적 데이터를 여행 중 사용하는 SubQuest 상태로 변환한다.
    func makeRandomSubQuest(
        triggeredAt: Date = .now
    ) -> SubQuest? {
        missions.randomElement().map { mission in
            SubQuest(
                id: UUID(),
                title: mission.title,
                isCompleted: false,
                triggeredAt: triggeredAt
            )
        }
    }
}

enum MissionProviderError: LocalizedError {
    case resourceNotFound(String)
    case unsupportedVersion(Int)
    case emptyCatalog
    case emptyTitle

    var errorDescription: String? {
        switch self {
        case .resourceNotFound(let resourceName):
            "\(resourceName).json을 앱 번들에서 찾을 수 없습니다."
        case .unsupportedVersion(let version):
            "지원하지 않는 미션 파일 버전입니다: \(version)"
        case .emptyCatalog:
            "미션 목록이 비어 있습니다."
        case .emptyTitle:
            "제목이 비어 있는 미션이 있습니다."
        }
    }
}
