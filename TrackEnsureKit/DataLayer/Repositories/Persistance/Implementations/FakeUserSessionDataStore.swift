//
//  FakeUserSessionDataStore.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public class FakeUserSessionDataStore: UserSessionDataStore {

    // MARK: - Properties
    let hasToken: Bool

    // MARK: - Methods
    public init(hasToken: Bool) {
        self.hasToken = hasToken
    }

    public func readUserSession(result: @escaping (Result<UserSession, Error>) -> Void) {
        hasToken ? runHasToken(result: result) : runDoesNotHaveToken(result: result)
    }

    public func save(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void) {
        result(.success(userSession))
    }

    public func delete(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void) {
        result(.success(userSession))
    }

    private func runHasToken(result: @escaping (Result<UserSession, Error>) -> Void) {
        print("Try to read user session from fake disk ...")
        print("  simulating having user session with token fak3_r3m0t3_t0k3n ...")
        print("  returning user session with token fak3_r3m0t3_t0k3n ...")
        let profile = UserProfile(name: "John Doe", email: "johndoe@gmail.com")
        let remoteSession = RemoteUserSession(token: "fak3_r3m0t3_t0k3n")
        return result(.success(UserSession(profile: profile, remoteSession: remoteSession)))
    }

    private func runDoesNotHaveToken(result: @escaping (Result<UserSession, Error>) -> Void) {
        print("Try to read user session from fake disk ...")
        print("  simulating empty disk ...")
        print("  returning nil ...")
        return result(.failure(DataStoreError.invalidToken))
    }
}
