//
//  Logging.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation
import OSLog

enum Log {
    static let subsystem: String = "net.condemned.injector"

    #if swift(>=6.0)
        #warning("Logger was marked as Sendable in Swift 6.0 / XCode 16")
    #endif
    nonisolated(unsafe) static let general: Logger = .init(subsystem: subsystem, category: "General")
    nonisolated(unsafe) static let resolver: Logger = .init(subsystem: subsystem, category: "resolver")
    nonisolated(unsafe) static let registry: Logger = .init(subsystem: subsystem, category: "registry")
    nonisolated(unsafe) static let collaborator: Logger = .init(subsystem: subsystem, category: "collaborator")
}
