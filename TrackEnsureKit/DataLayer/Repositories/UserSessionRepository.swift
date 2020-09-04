//
//  UserSessionRepository.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public protocol UserSessionRepository {
    
    func readUserSession(result: @escaping (Result<UserSession, Error>) -> Void)
    func signIn(email: String, password: String, result: @escaping (Result<UserSession, Error>) -> Void)
    func signUp(newAccount: NewAccount, result: @escaping (Result<UserSession, Error>) -> Void)
    func signOut(userSession: UserSession, result: @escaping (Result<UserSession, Error>) -> Void)
}
