import XCTest
@testable import Injector

struct S<each T: Equatable> {
  let function: (repeat each T) -> Void

  func test(_ t: repeat each T)  {
    function(repeat each t)
  }
}

final class InjectorTests: XCTestCase {
    func testExample() throws {
        let s = S(function: { a, b in
            let a: Int = a
            let b: Bool = b
            print("a \(a) - b \(b)")
        })
        
        s.test(5, true)
    }
    
    
}
