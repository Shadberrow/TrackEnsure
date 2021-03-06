//
//  AuthRemoteApi.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public enum AuthRemoteApiError: Error {
    case unknown
}

public protocol AuthRemoteApi {
    
    func signIn(email: String, password: String, result: @escaping (Result<UserSession, Error>) -> Void)
    func signUp(account: NewAccount, result: @escaping (Result<UserSession, Error>) -> Void)
}
