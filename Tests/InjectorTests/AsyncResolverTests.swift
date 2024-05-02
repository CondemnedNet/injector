//
//  AsyncResolverTests.swift
//
//  Copyright © 2024 Condemned.net.
//

@testable import Injector
import XCTest

final class AsyncResolverTests: XCTestCase {
    var container: Container!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        container = Container()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        container = nil
    }

    func testResolveReturnsCapturedInstance() async throws {
        let concrete = await MockServiceImp1.asyncFactory()
        let implemented: MockService = await MockServiceImp1.asyncFactory()

        container.register { _ throws -> MockService in implemented }
        await container.register(instance: concrete)

        let resolvedImpl = try await container.resolve() as MockService
        let resolvedConc = try await container.resolve(MockServiceImp1.self)
        XCTAssertIdentical(resolvedImpl, implemented)
        XCTAssertIdentical(resolvedConc, concrete)
    }

    func testResolveSingletonReturnsSameInstance() async throws {
        container.register(scope: .singleton) { _ in
            await MockServiceImp1.asyncFactory()
        }

        let firstResolved = try await container.resolve() as MockServiceImp1
        let secondResolved = try await container.resolve(MockServiceImp1.self)

        XCTAssertIdentical(firstResolved, secondResolved)
    }

    func testAsyncResolveSingletonReturnsSameInstance() async throws {
        container.register(scope: .singleton) { _ throws -> MockServiceImp1 in
            MockServiceImp1()
        }

        let firstResolved = try await container.resolve() as MockServiceImp1
        let secondResolved = try await container.resolve(MockServiceImp1.self)

        XCTAssertIdentical(firstResolved, secondResolved)
    }

    func testResolveAsyncRegisrationWithSyncThrowsError() async throws {
        container.register(scope: .singleton) { _ in
            await MockServiceImp1.asyncFactory()
        }

        let closure: () throws -> MockService = {
            try self.container.resolve() as MockServiceImp1
        }

        XCTAssertThrowsError(try closure()) {
            if case let .requiresAsync(message) = $0 as? InjectorError, let message {
                XCTAssertEqual(message, "Type was registered with an async constructor!")
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }

    func testThrowingRandomErrorThrowsInjectionError() async throws {
        container.register { _ in
            try ThrowingMockService(error: MockError.testError) as MockService
        }

        await XCTAssertAsyncThrowsError(try await container.resolve() as MockService) {
            if case let .other(error) = $0 as? InjectorError, let mockError = error as? MockError {
                XCTAssertEqual(mockError, MockError.testError)
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }

    func testThrowingInjectionErrorThrowsInjectionError() async throws {
        let registration = Registration(type: Int.self)
        container.register { _ in
            try ThrowingMockService(error: InjectorError.notFound(registration)) as MockService
        }

        await XCTAssertAsyncThrowsError(try await container.resolve() as MockService) {
            if case let .notFound(reg) = $0 as? InjectorError {
                XCTAssertEqual(registration, reg)
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }

    func testResolvingUnregisteredThrowsNotFound() async throws {
        await XCTAssertAsyncThrowsError(try await container.resolve() as MockService) {
            if case let .notFound(reg) = $0 as? InjectorError {
                XCTAssertEqual("InjectorTests.MockService", reg.type)
            } else {
                XCTFail("Got the wrong error! \($0)")
            }
        }
    }

    func testResolvingUniqueReturnsNewInstance() async throws {
        container.register(scope: .unique) { _ in
            await MockServiceImp1.asyncFactory("Rand: \(Int.random(in: 0 ..< 100))") as MockService
        }

        let firstResolved = try await container.resolve() as MockService
        let secondResolved = try await container.resolve() as MockService

        XCTAssertNotIdentical(firstResolved, secondResolved)
    }

    func testResolvingSingletonReturnsSameInstance() async throws {
        container.register(scope: .singleton) { _ in
            await MockServiceImp1.asyncFactory("Rand: \(Int.random(in: 0 ..< 100))") as MockService
        }

        let firstResolved = try await container.resolve() as MockService
        let secondResolved = try await container.resolve() as MockService

        XCTAssertIdentical(firstResolved, secondResolved)
    }
}
