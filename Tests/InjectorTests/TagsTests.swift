//
//  TagsTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class TagsTests: XCTestCase {
    func testTagsEquals() throws {
        let set: Set<AnyHashable> = ["mock", "test"]
        let tags: Criteria.TagSet = .equals(set)
        XCTAssertTrue(tags ~= ["test", "mock"])
    }

    func testVariadicTagsEquals() throws {
        let tags: Criteria.TagSet = .equals("mock", "test")
        XCTAssertTrue(tags ~= ["test", "mock"])
    }

    func testTagsContains() throws {
        let set: Set<AnyHashable> = ["mock", "test"]
        let tags: Criteria.TagSet = .contains(set)
        XCTAssertTrue(tags ~= ["mock", "test", "other"])
    }

    func testVariadicTagsContains() throws {
        let tags: Criteria.TagSet = .contains("mock", "test")
        XCTAssertTrue(tags ~= ["mock", "test", "other"])
    }
}
