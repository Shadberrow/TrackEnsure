//
//  SignedInResponder.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public protocol SignedInResponder {

    func signedIn(to userSession: UserSession)
}
