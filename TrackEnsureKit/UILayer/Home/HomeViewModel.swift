//
//  HomeViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public class HomeViewModel: SignOutResponder {

    // MARK: - Properties
    let userSession: UserSession
    let createRecordResponder: CreateRecordResponder
    let notSignedInResponder: NotSignedInResponder
    let userSessionRepository: UserSessionRepository

    // MARK: - Methods
    public init(userSession: UserSession,
                createRecordResponder: CreateRecordResponder,
                notSignedInResponder: NotSignedInResponder,
                userSessionRepository: UserSessionRepository) {
        self.userSession = userSession
        self.createRecordResponder = createRecordResponder
        self.notSignedInResponder = notSignedInResponder
        self.userSessionRepository = userSessionRepository
    }

    public func handleAddAction() {
        createRecordResponder.goToRecordCreation()
    }

    public func signOut() {
        switch userSessionRepository.signOut(userSession: userSession) {
        case let .failure(error): print(error)
        case .success: notSignedInResponder.notSignedIn() }
    }
}
