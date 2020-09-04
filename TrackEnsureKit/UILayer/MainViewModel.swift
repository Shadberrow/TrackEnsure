//
//  MainViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine
import Firebase

public class MainViewModel: SignedInResponder, NotSignedInResponder {

    // MARK: - Properties
    public var viewPublisher: AnyPublisher<MainView, Never> { return viewSubject.eraseToAnyPublisher() }
    private let viewSubject = CurrentValueSubject<MainView, Never>(.launching)

    // MARK: - Methods
    public init() {
        FirebaseApp.configure()
    }

    // MARK: - SignedInResponder Implementation
    public func signedIn(to userSession: UserSession) {
        viewSubject.send(.signedIn(userSession: userSession))
    }

    // MARK: - NotSignedInResponder Implementation
    public func notSignedIn() {
        viewSubject.send(.onboarding)
    }

}
