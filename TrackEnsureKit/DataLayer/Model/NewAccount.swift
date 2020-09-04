//
//  NewAccount.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public struct NewAccount: Codable {

    // MARK: - Properties
    let name: String
    let email: String
    let password: String

    // MARK: - Methods
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
