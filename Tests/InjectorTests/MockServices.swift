//
//  MockServices.swift
//
//  Copyright © 2024 Condemned.net.
//

// swiftlint:disable file_types_order
import Foundation
@testable import Injector

public enum MockError: Error {
    case testError
}

public protocol MockService: AnyObject {
    var string: String { get }
}

public class MockServiceImp1: MockService, CustomStringConvertible {
    public let string: String

    public var description: String {
        return "\(type(of: self)) - String: \(string) - Location: \(Unmanaged.passUnretained(self).toOpaque())"
    }

    init(_ string: String? = nil) {
        self.string = string ?? "DEFAULT"
        print("Just instantiated \(self)")
    }

    static func asyncFactory(_ string: String? = nil) async -> MockServiceImp1 {
        return MockServiceImp1("ASYNC \(string ?? "DEFAULT")")
    }
}

public class ThrowingMockService: MockService {
    public var string: String {
        return "THROW"
    }

    init(error: any Error) throws {
        throw error
    }
}

public class BadCollaborator: Resolver, Collaborator {
    public var collaborators: [any Injector.Resolver] = []

    public func collaborate(with _: [any Injector.Resolver]) {
        // No-op
    }

    public func locate(_: Injector.Registration) -> [Injector.Registration: any Injector.Injectable] {
        return [:]
    }
}

// swiftlint:enable file_types_order
