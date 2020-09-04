//
//  SignedInViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Combine

public class SignedInViewModel: CreateRecordResponder {

    // MARK: - Properties
    // Combine
    public var viewPublisher: AnyPublisher<SignedInView, Never> { return viewSubject.eraseToAnyPublisher() }
    private let viewSubject = CurrentValueSubject<SignedInView, Never>(.home)

    // MARK: - Methods
    public init() { }

    public func presentProfileScreen() {
        viewSubject.send(.profile)
    }

    public func goToRecordCreation() {
        viewSubject.send(.addRecord)
    }
}
