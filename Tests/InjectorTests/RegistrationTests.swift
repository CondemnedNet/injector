//
//  RegistrationTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class RegistrationTests: XCTestCase {
    func testRegistrationOfTypeAloneIsCreatedProperly() throws {
        let registration = Registration(type: String.self)
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags, [])
        XCTAssertEqual(registration.arguments, String(reflecting: Void.self))
    }

    func testRegistrationOfTypeAndTags() throws {
        let uuid = UUID()
        let registration = Registration(type: String.self, tags: ["1", uuid.uuidString])
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags, ["1", uuid.uuidString])
        XCTAssertEqual(registration.arguments, String(reflecting: Void.self))
    }

    func testRegistrationOfTypeAndArguments() throws {
        let registration = Registration(type: String.self, arguments: type(of: 12))
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.arguments, String(reflecting: Int.self))
    }

    func testRegistrationOfTypeTagsAndArguments() throws {
        let uuid = UUID()
        let registration = Registration(type: String.self, arguments: type(of: (12, "Hello", MockServiceImp1())), tags: ["23", uuid.uuidString])
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags, ["23", uuid.uuidString])
        XCTAssertEqual(registration.arguments, String(reflecting: (Int, String, MockServiceImp1).self))
    }
}
