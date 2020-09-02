//
//  UserSessionDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public enum DataStoreError: Error {
    case badCedentials
    case invalidToken
    case userNotFound
    case unknown
}

public protocol UserSessionDataStore {

    func readUserSession() -> Result<UserSession, Error>
    func save(userSession: UserSession) -> Result<UserSession, Error>
    func delete(userSession: UserSession) -> Result<UserSession, Error>
}
