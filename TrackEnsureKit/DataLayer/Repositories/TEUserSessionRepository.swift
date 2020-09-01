//
//  TEUserSessionRepository.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public class TEUserSessionRepository: UserSessionRepository {

    // MARK: - Properties
    let dataStore: UserSessionDataStore
    let remoteApi: AuthRemoteApi


    // MARK: - Methods
    public init(dataStore: UserSessionDataStore, remoteApi: AuthRemoteApi) {
        self.dataStore = dataStore
        self.remoteApi = remoteApi
    }

    // MARK: - UserSessionRepository Implementation
    public func readUserSession() -> Future<UserSession, Error> {
        return dataStore.readUserSession()
    }

    public func signIn(email: String, password: String) -> Future<UserSession, Error> {
        return remoteApi.signIn(email: email, password: password)
    }

    public func signUp(newAccount: NewAccount) -> Future<UserSession, Error> {
        return remoteApi.signUp(account: newAccount)
    }

    public func signOut(userSession: UserSession) -> Future<UserSession, Error> {
        return dataStore.delete(userSession: userSession)
    }
}
