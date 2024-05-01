//
//  RegistryTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class RegistryTests: XCTestCase {
    var container: Container!

    override func setUpWithError() throws {
        container = Container()
    }

    override func tearDownWithError() throws {
        container = nil
    }

    func testRegistrationOfOneDependency() throws {
        container.register { _ in MockServiceImp1() as MockService }

        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }

    func testDoubleRegistrationOnlyRegistersOneInstance() throws {
        container.register { _ in MockServiceImp1() as MockService }
        container.register(MockService.self, instance: MockServiceImp1())

        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }

    func testAsyncRegistrationOfOneDependency() async throws {
        container.register { _ in await MockServiceImp1.asyncFactory() as MockService }

        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }

    func testAsyncDoubleRegistrationOnlyRegistersOneInstance() async throws {
        container.register { _ in await MockServiceImp1.asyncFactory() as MockService }
        await container.register(MockService.self, instance: await MockServiceImp1.asyncFactory())

        XCTAssertFalse(container.dependencies.isEmpty)
        XCTAssertEqual(container.dependencies.count, 1)
        let registration = Registration(type: MockService.self)
        XCTAssertNotNil(container.dependencies[registration])
    }
}
