//
//  FakeAuthRemoteApi.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public struct FakeAuthRemoteApi: AuthRemoteApi {

    // MARK: - Methods
    public init() {}

    public func signIn(email: String, password: String, result: @escaping (Result<UserSession, Error>) -> Void) {
        let profile = email == "johndoe@gmail.com" && password == "password" ?
            UserProfile(name: "John Doe", email: email) : UserProfile(name: "[R] "+email, email: email)
        let remoteUserSession = RemoteUserSession(token: "j0hnd03_signed_in")
        let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
        result(.success(userSession))
    }

    public func signUp(account: NewAccount, result: @escaping (Result<UserSession, Error>) -> Void) {
        let profile = UserProfile(name: account.name, email: account.email)
        let remoteUserSession = RemoteUserSession(token: "j0hnd03_signed_up")
        let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
        result(.success(userSession))
    }
}
