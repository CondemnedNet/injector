//
//  Errors.swift
//
//
//  Created by Karl Catigbe on 4/3/24.
//

import Foundation

public enum InjectorError: Error {
    case notFound(Registration)
    case other(Error)
    case requiresAsync(String?)
}
