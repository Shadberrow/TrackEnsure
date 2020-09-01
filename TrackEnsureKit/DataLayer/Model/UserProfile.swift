//
//  UserProfile.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct UserProfile: Codable, Equatable {

    // MARK: - Properties
    public let name: String
    public let email: String

    // MARK: - Methods
    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
