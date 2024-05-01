//
//  WeakWrapper.swift
//
//  Copyright © 2024 Condemned.net.
//

import Foundation

struct WeakWrapper<T: AnyObject> {
    weak var value: T?

    init(value: T? = nil) {
        self.value = value
    }
}
