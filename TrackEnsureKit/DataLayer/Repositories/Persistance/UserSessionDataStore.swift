//
//  UserSessionDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public enum DataStoreError: Error {
    case badCedentials
    case invalidToken
    case userNotFound
    case unknown
}

public protocol UserSessionDataStore {

    func readUserSession(result: @escaping (Result<UserSession, Error>) -> Void)
    func save(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void)
    func delete(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void)
}
