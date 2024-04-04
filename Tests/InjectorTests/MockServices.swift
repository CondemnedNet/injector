//
//  MockServices.swift
//  
//
//  Created by Karl Catigbe on 4/4/24.
//

import Foundation

public enum MockError: Error {
    case testError
}

public protocol MockService: AnyObject { }

public class MockServiceImp1: MockService { 
    let string: String
    
    convenience init() {
        self.init(string: "DEFAULT")
    }
    
    init(string: String) {
        self.string = string
        print("\(type(of: self)) - Just instantiated \(self.string)")
    }
}

public class ThrowingMockService: MockService {
    init(error: MockError) throws {
        throw error
    }
}