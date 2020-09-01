//
//  OnboardingViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public class OnboardingViewModel {

    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder

    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder
    }
}
