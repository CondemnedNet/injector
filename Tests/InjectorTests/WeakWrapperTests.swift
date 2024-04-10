//
//  WeakWrapperTests.swift
//  
//
//  Created by Karl Catigbe on 4/10/24.
//

import XCTest
@testable import Injector

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
