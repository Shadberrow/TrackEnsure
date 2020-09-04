//
//  UserSession.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public class UserSession: Codable, Equatable {

    // MARK: - Properties
    public let profile: UserProfile
    public let remoteSession: RemoteUserSession

    // MARK: - Methods
    public init(profile: UserProfile, remoteSession: RemoteUserSession) {
        self.profile = profile
        self.remoteSession = remoteSession
    }

    public static func == (lhs: UserSession, rhs: UserSession) -> Bool {
           return lhs.profile == rhs.profile &&
               lhs.remoteSession == rhs.remoteSession
       }
}
