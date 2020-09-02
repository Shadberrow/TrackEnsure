//
//  OnboardingViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Combine

public class OnboardingViewModel {

    typealias SignInCredentials = (email: String, password: String)
    typealias SignUpCredentials = (name: String, email: String, password: String)
    typealias Credentials = (name: String, email: String, password: String)

    enum Mode: Int {
        case signIn, signUp
    }

    // MARK: - Properties
    let userSessionRepository: UserSessionRepository
    let signedInResponder: SignedInResponder

    var minPasswordLength = 4
    var minNameLength = 4

    // Combine

    public var isButtonEnabled: AnyPublisher<Bool, Never> { return isButtonEnabledSubject.eraseToAnyPublisher() }

    public let nameSubject = CurrentValueSubject<String?, Never>(nil)
    public let emailSubject = CurrentValueSubject<String?, Never>(nil)
    public let passwordSubject = CurrentValueSubject<String?, Never>(nil)
    public let onboardingModeSubject = CurrentValueSubject<Int, Never>(0)

    private let isButtonEnabledSubject = CurrentValueSubject<Bool, Never>(true)
    private let credentialsSubject = CurrentValueSubject<Credentials, Never>(("", "", ""))

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(userSessionRepository: UserSessionRepository,
                signedInResponder: SignedInResponder) {
        self.userSessionRepository = userSessionRepository
        self.signedInResponder = signedInResponder

        let validatedSignInCredentials = credentialsSubject
            .map({ ($0.email, $0.password) })
            .map({ !$0.isEmpty && !$1.isEmpty && $1.count > 4 })
            .eraseToAnyPublisher()
        let validatedSignUpCredentials = credentialsSubject
            .map({ !$0.name.isEmpty && !$0.email.isEmpty && !$0.password.isEmpty && $0.password.count > 4 && $0.name.count > 4 })
            .eraseToAnyPublisher()

        self.nameSubject.combineLatest(emailSubject, passwordSubject)
            .map { ($0 ?? "", $1 ?? "", $2 ?? "") }
            .sink { [unowned self] in self.credentialsSubject.send($0) }
            .store(in: &subscriptions)

        self.onboardingModeSubject
            .combineLatest(validatedSignInCredentials, validatedSignUpCredentials) { mode, a, b in
                switch mode {
                case Mode.signIn.rawValue: return a
                case Mode.signUp.rawValue: return b
                default: return false } }
            .subscribe(isButtonEnabledSubject).store(in: &subscriptions)
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public func signUp() {
        let credentials = credentialsSubject.value
        let newAccount = NewAccount(name: credentials.name, email: credentials.email, password: credentials.password)
        switch userSessionRepository.signUp(newAccount: newAccount) {
        case let .failure(error): print(#line, "Handle Error: ", error, #file)
        case let .success(session): self.signedInResponder.signedIn(to: session) }
    }

    public func signIn() {
//        let credentials = credentialsSubject.value
        let credentials = (name: "", email: "johndoe@gmail.com", password: "password")
        switch userSessionRepository.signIn(email: credentials.email, password: credentials.password) {
        case let .failure(error): print(#line, "Handle Error: ", error, #file)
        case let .success(session): self.signedInResponder.signedIn(to: session) }
    }
}
