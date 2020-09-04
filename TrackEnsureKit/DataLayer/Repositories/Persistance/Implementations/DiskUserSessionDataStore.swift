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
    public func readUserSession() -> Result<UserSession, Error> {
        guard let data = UserDefaults.standard.data(forKey: "App.UserSession") else {
            return .failure(DiskUserSessionDataStoreError.notSignedIn)
        }
        guard let session = try? JSONDecoder().decode(UserSession.self, from: data) else {
            return .failure(DiskUserSessionDataStoreError.decoderFailed)
        }
        return .success(session)
    }

    public func save(userSession: UserSession) -> Result<UserSession, Error> {
        guard let data = try? JSONEncoder().encode(userSession) else { return .failure(DiskUserSessionDataStoreError.encoderFailed) }
        UserDefaults.standard.set(data, forKey: "App.UserSession")
        return .success(userSession)
    }

    public func delete(userSession: UserSession) -> Result<UserSession, Error> {
        UserDefaults.standard.set(nil, forKey: "App.UserSession")
        return .success(userSession)
    }
}
