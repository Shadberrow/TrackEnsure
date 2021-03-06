//
//  OnboardingViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Combine

public class OnboardingViewModel {

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

    public var buttonTitlePublisher: AnyPublisher<String?, Never> { return buttonTitleSubject.eraseToAnyPublisher() }
    public var isButtonEnabled: AnyPublisher<Bool, Never> { return isButtonEnabledSubject.eraseToAnyPublisher() }

    public let nameSubject = CurrentValueSubject<String?, Never>(nil)
    public let emailSubject = CurrentValueSubject<String?, Never>(nil)
    public let passwordSubject = CurrentValueSubject<String?, Never>(nil)
    public let onboardingModeSubject = CurrentValueSubject<Int, Never>(0)
    public let beginEditingSubject = PassthroughSubject<Void, Never>()

    private let buttonTitleSubject = CurrentValueSubject<String?, Never>("Sign In")
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

        self.onboardingModeSubject
            .map { mode in
                switch mode {
                case Mode.signIn.rawValue: return "Sign In"
                case Mode.signUp.rawValue: return "Sign Up"
                default: return "Default" } }
            .subscribe(buttonTitleSubject).store(in: &subscriptions)
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public func signUp() {
        let credentials = credentialsSubject.value
        let newAccount = NewAccount(name: credentials.name, email: credentials.email, password: credentials.password)
        userSessionRepository.signUp(newAccount: newAccount) { [unowned self] result in
            switch result {
            case let .failure(error): print(#line, "Handle Error: ", error, #file)
            case let .success(session): self.signedInResponder.signedIn(to: session)
            }
        }
    }

    public func signIn() {
        let credentials = credentialsSubject.value
        userSessionRepository.signIn(email: credentials.email, password: credentials.password)  { [unowned self] result in
            switch result {
            case let .failure(error): print(#line, "Handle Error: ", error, #file)
            case let .success(session): self.signedInResponder.signedIn(to: session)
            }
        }
    }

    public func beginEditing() {
        beginEditingSubject.send(())
    }
}
