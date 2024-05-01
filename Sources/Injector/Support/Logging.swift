//
//  Logging.swift
//
//
//  Created by Karl Catigbe on 4/24/24.
//

import Foundation
import OSLog

enum Log {
    static var subsystem: String = "net.condemned.injector"
    static var general: Logger = { return Logger(subsystem: subsystem, category: "General") }()
    static var resolver: Logger = { return Logger(subsystem: subsystem, category: "resolver") }()
    static var registry: Logger = { return Logger(subsystem: subsystem, category: "registry") }()
    static var collaborator: Logger = { return Logger(subsystem: subsystem, category: "collaborator") }()
}
