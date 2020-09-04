//
//  DiskUserSessionDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public enum DiskUserSessionDataStoreError: Error {
    case notSignedIn
    case encoderFailed
    case decoderFailed
}

public class DiskUserSessionDataStore: UserSessionDataStore {

    public init() {}

    // MARK: - Methods
    public func readUserSession(result: @escaping (Result<UserSession, Error>) -> Void) {
        guard let data = UserDefaults.standard.data(forKey: "App.UserSession") else {
            return result(.failure(DiskUserSessionDataStoreError.notSignedIn))
        }
        guard let session = try? JSONDecoder().decode(UserSession.self, from: data) else {
            return result(.failure(DiskUserSessionDataStoreError.decoderFailed))
        }
        result(.success(session))
    }

    public func save(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void) {
        guard let data = try? JSONEncoder().encode(userSession) else {
            return result(.failure(DiskUserSessionDataStoreError.encoderFailed))
        }
        UserDefaults.standard.set(data, forKey: "App.UserSession")
        result(.success(userSession))
    }

    public func delete(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void) {
        UserDefaults.standard.set(nil, forKey: "App.UserSession")
        result(.success(userSession))
    }
}
