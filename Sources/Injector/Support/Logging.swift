//
//  Logging.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation
import OSLog

enum Log {
    static var subsystem: String = "net.condemned.injector"
    static var general: Logger = .init(subsystem: subsystem, category: "General")
    static var resolver: Logger = .init(subsystem: subsystem, category: "resolver")
    static var registry: Logger = .init(subsystem: subsystem, category: "registry")
    static var collaborator: Logger = .init(subsystem: subsystem, category: "collaborator")
}
