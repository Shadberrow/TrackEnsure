//
//  FirebaseAuthRemoteApi.swift
//  TrackEnsure
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import FirebaseAuth

public enum FirebaseAuthRemoteApiError: Error {
    case googleSignUpError(Error)
    case googleSignInError(Error)
}

public class FirebaseAuthRemoteApi: AuthRemoteApi {

    // MARK: - Methods
    public init() {}

    public func signIn(email: String, password: String, result: @escaping (Result<UserSession, Error>) -> Void)  {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if let error = error { return result(.failure(FirebaseAuthRemoteApiError.googleSignInError(error))) }
            if let response = response {
                let profile = UserProfile(name: response.user.displayName ?? "N/A", email: email)
                let remoteSession = RemoteUserSession(token: response.user.uid)
                let userSession = UserSession(profile: profile, remoteSession: remoteSession)
                return result(.success(userSession))
            }
        }
    }

    public func signUp(account: NewAccount, result: @escaping (Result<UserSession, Error>) -> Void)  {
        FirebaseAuth.Auth.auth().createUser(withEmail: account.email, password: account.password) { (response, error) in
            if let error = error { return result(.failure(FirebaseAuthRemoteApiError.googleSignUpError(error))) }
            if let response = response {
                let profile = UserProfile(name: account.name, email: account.email)
                let remoteSession = RemoteUserSession(token: response.user.uid)
                let userSession = UserSession(profile: profile, remoteSession: remoteSession)
                return result(.success(userSession))
            }
        }
    }
}
