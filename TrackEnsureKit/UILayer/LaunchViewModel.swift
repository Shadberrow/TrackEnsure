//
//  LaunchViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Combine

public class LaunchViewModel {

    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let notSignedInResponder: NotSignedInResponder
    let signedInResponder: SignedInResponder

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    private let errorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                notSignedInResponder: NotSignedInResponder,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.notSignedInResponder = notSignedInResponder
        self.signedInResponder = signedInResponder
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public func loadUserSession() {
        switch self.userSessionRepository.readUserSession() {
        case let .success(session): self.signedInResponder.signedIn(to: session)
        case .failure: self.notSignedInResponder.notSignedIn() }
    }
}
