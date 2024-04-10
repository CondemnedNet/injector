//
//  TagsTests.swift
//  
//
//  Created by Karl Catigbe on 4/14/24.
//

import XCTest
@testable import Injector

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
