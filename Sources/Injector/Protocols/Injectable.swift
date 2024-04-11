//
//  Injectable.swift
//  
//
//  Created by Karl Catigbe on 4/10/24.
//

import Foundation

public protocol Injectable: AnyObject {
    var scope: Scope { get }
    
    func resolve(_ container: any Resolver, arguments: Any) throws -> Any
}
