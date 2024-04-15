//
//  MockServices.swift
//
//
//  Created by Karl Catigbe on 4/4/24.
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
    
    init(_ string: String? = nil) {
        self.string = string ?? "DEFAULT"
        print("Just instantiated \(self)")
    }
    
    public var description: String {
        return "\(type(of: self)) - String: \(string) - Location: \(Unmanaged.passUnretained(self).toOpaque())"
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
    
    public func collaborate(with collaborators: [any Injector.Resolver]) {
        // No-op
    }
    
    public func locate(_ registration: Injector.Registration) -> [Injector.Registration : any Injector.Injectable] {
        return [:]
    }
}
