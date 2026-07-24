//
//  DeepLinkRouter.swift
//  CheongamConan
//
//  Created by Dayoon Lee on 7/23/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class DeepLinkRouter {
    enum Route: Equatable {
        case missionCamera(missionID: UUID)
    }
    
    private(set) var route: Route?
    
    func handle(_ url: URL) {
        guard url.scheme == "tenten", url.host == "mission" else {
            return
        }
        
        let components = url.pathComponents.filter { $0 != "/" }
        
        guard components.count == 2,
              let missionID = UUID(uuidString: components[0]),
              components[1] == "camera" else {
            return
        }
        route = .missionCamera(missionID: missionID)
    }
    
    func consume() {
        route = nil
    }
}
