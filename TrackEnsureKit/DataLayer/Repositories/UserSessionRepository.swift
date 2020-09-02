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
    
    func readUserSession() -> Result<UserSession, Error>
    func signIn(email: String, password: String) -> Result<UserSession, Error>
    func signUp(newAccount: NewAccount) -> Result<UserSession, Error>
    func signOut(userSession: UserSession) -> Result<UserSession, Error>
}
