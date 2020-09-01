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

    public func signIn(email: String, password: String) -> Future<UserSession, Error> {
        guard email == "johndoe@gmail.com" && password == "password" else {
            return Future { $0(.failure(AuthRemoteApiError.unknown)) }
        }

        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                let profile = UserProfile(name: "John Doe", email: "johndoe@gmail.com")
                let remoteUserSession = RemoteUserSession(token: "j0hnd03_signed_in")
                let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
                promise(.success(userSession))
            }
        }
    }

    public func signUp(account: NewAccount) -> Future<UserSession, Error> {
        return Future { promise in
            let profile = UserProfile(name: account.name, email: account.email)
            let remoteUserSession = RemoteUserSession(token: "j0hnd03_signed_up")
            let userSession = UserSession(profile: profile, remoteSession: remoteUserSession)
            promise(.success(userSession))
        }
    }
}
