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

    public func readUserSession() -> Future<UserSession, Error> {
        return hasToken ? runHasToken() : runDoesNotHaveToken()
    }

    public func save(userSession: UserSession) -> Future<UserSession, Error> {
        return Future { $0(.success(userSession)) }
    }

    public func delete(userSession: UserSession) -> Future<UserSession, Error> {
        return Future { $0(.success(userSession)) }
    }

    private func runHasToken() -> Future<UserSession, Error> {
        print("Try to read user session from fake disk ...")
        print("  simulating having user session with token fak3_r3m0t3_t0k3n ...")
        print("  returning user session with token fak3_r3m0t3_t0k3n ...")
        let profile = UserProfile(name: "John Doe", email: "johndoe@gmail.com")
        let remoteSession = RemoteUserSession(token: "fak3_r3m0t3_t0k3n")
        return Future { $0(.success(UserSession(profile: profile, remoteSession: remoteSession))) }
    }

    private func runDoesNotHaveToken() -> Future<UserSession, Error> {
        print("Try to read user session from fake disk ...")
        print("  simulating empty disk ...")
        print("  returning nil ...")
        return Future { $0(.failure(DataStoreError.invalidToken)) }
    }
}
