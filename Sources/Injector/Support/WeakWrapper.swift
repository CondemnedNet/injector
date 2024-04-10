//
//  WeakWrapper.swift
//
//
//  Created by Karl Catigbe on 4/10/24.
//

import Foundation

struct WeakWrapper<T: AnyObject> {
    weak var value: T?
    
    init(value: T? = nil) {
        self.value = value
    }
}
