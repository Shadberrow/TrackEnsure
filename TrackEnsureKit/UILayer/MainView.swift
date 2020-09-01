//
//  MainView.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public enum MainView {

    case launching
    case onboarding
    case signedIn(userSession: UserSession)
}
