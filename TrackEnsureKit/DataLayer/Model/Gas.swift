//
//  Gas.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct Gas: Codable, Equatable {

    // MARK: - Properties
    public let provider: String
    public let type: String

    // MARK: - Methods
    public init(provider: String, type: String) {
        self.provider = provider
        self.type = type
    }
}
