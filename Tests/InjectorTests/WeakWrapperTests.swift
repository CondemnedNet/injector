//
//  WeakWrapperTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class WeakWrapperTests: XCTestCase {
    func testWeakWrapperReleasesObject() throws {
        var mockObject: MockServiceImp1? = MockServiceImp1("Weakly Boxed")

        let weakBox = WeakWrapper(value: mockObject)

        XCTAssertNotNil(weakBox.value)
        XCTAssertTrue(weakBox.value === mockObject)

        mockObject = nil
        XCTAssertNil(weakBox.value)
        XCTAssertNil(mockObject)
    }
}
