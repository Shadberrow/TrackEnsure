//
//  AuthRemoteApi.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

public protocol AuthRemoteApi {
    
    func signIn(email: String, password: String) -> Future<UserSession, AuthRemoteApiError>
    func signUp(account: NewAccount) -> Future<UserSession, AuthRemoteApiError>
}
