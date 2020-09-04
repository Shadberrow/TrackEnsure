//
//  Undefined.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

public func undefined<T>(_ message: String = "") -> T {
    fatalError(message)
}
