//
//  Errors.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

public enum InjectorError: Error {
    case notFound(Registration)
    case other(Error)
    case requiresAsync(String?)
}
