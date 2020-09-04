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
    public func readUserSession(result: @escaping (Result<UserSession, Error>) -> Void) {
        return dataStore.readUserSession(result: result)
    }

    public func signIn(email: String, password: String, result: @escaping (Result<UserSession, Error>) -> Void) {
        remoteApi.signIn(email: email, password: password) { signInResult in
            switch signInResult {
            case let .success(session): return self.dataStore.save(userSession: session, result: result)
            case let .failure(error): return result(.failure(error))
            }
        }
    }

    public func signUp(newAccount: NewAccount, result: @escaping (Result<UserSession, Error>) -> Void) {
        remoteApi.signUp(account: newAccount) { signUpResult in
            switch signUpResult {
            case let .success(session): return self.dataStore.save(userSession: session, result: result)
            case let .failure(error): return result(.failure(error))
            }
        }
    }

    public func signOut(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void) {
        return dataStore.delete(userSession: userSession, result: result)
    }
}
