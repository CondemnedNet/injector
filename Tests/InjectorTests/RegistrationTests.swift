//
//  RegistrationTests.swift
//  
//
//  Created by Karl Catigbe on 4/4/24.
//

import XCTest
@testable import Injector

final class RegistrationTests: XCTestCase {
    
    func testRegistrationOfTypeAloneIsCreatedProperly() throws {
    
        let registration = Registration(type: String.self)
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags, [])
        XCTAssertEqual(registration.arguments, String(reflecting: Void.self))
    }

    func testRegistrationOfTypeAndTags() throws {
        let uuid = UUID()
        let registration = Registration(type: String.self, tags: ["1", uuid])
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags, ["1", uuid])
        XCTAssertEqual(registration.arguments, String(reflecting: Void.self))
    }
    
    func testRegistrationOfTypeAndArguments() throws {
        let registration = Registration(type: String.self, arguments: type(of: 12))
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.arguments, String(reflecting: Int.self))
    }
    
    func testRegistrationOfTypeTagsAndArguments() throws {
        let uuid = UUID()
        let registration = Registration(type: String.self, arguments: type(of: (12, "Hello", MockServiceImp1())), tags: ["23", uuid])
        XCTAssertEqual(registration.type, String(reflecting: String.self))
        XCTAssertEqual(registration.tags,  ["23", uuid])
        XCTAssertEqual(registration.arguments, String(reflecting: (Int, String, MockServiceImp1).self))
    }
}
