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
    func readUserSession() -> Future<UserSession, Never>
    func signIn(email: String, password: String) -> Future<UserSession, Never>
    func signUp(newAccount: NewAccount) -> Future<UserSession, Never>
    func signOut(userSession: UserSession) -> Future<UserSession, Never>
}
