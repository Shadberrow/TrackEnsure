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
    public func readUserSession() -> Result<UserSession, Error> {
        return dataStore.readUserSession()
    }

    public func signIn(email: String, password: String) -> Result<UserSession, Error> {
        switch remoteApi.signIn(email: email, password: password) {
        case let .success(session): return dataStore.save(userSession: session)
        case let .failure(error): return .failure(error) }
    }

    public func signUp(newAccount: NewAccount) -> Result<UserSession, Error> {
        switch remoteApi.signUp(account: newAccount) {
        case let .success(session): return dataStore.save(userSession: session)
        case let .failure(error): return .failure(error) }
    }

    public func signOut(userSession: UserSession) -> Result<UserSession, Error> {
        return dataStore.delete(userSession: userSession)
    }
}
