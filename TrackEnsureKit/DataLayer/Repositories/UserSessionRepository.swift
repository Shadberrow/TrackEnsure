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
    
    func readUserSession() -> Future<UserSession, Error>
    func signIn(email: String, password: String) -> Future<UserSession, Error>
    func signUp(newAccount: NewAccount) -> Future<UserSession, Error>
    func signOut(userSession: UserSession) -> Future<UserSession, Error>
}
