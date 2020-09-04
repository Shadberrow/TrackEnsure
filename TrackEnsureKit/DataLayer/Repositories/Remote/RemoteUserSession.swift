//
//  RemoteUserSession.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct RemoteUserSession: Codable, Equatable {

    // MARK: - Properties
    let token: String

    // MARK: - Methods
    public init(token: String) {
        self.token = token
    }
}
