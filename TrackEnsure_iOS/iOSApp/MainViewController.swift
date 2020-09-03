//
//  MainViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import TrackEnsureUIKit
import TrackEnsureKit
import Combine

public class MainViewController: NiblessNavigationController {

    // MARK: - Properties
    // View Model
    let viewModel: MainViewModel

    // Child View Controller
    let launchViewController: LaunchViewController
    var onboardingViewController: OnboardingViewController?
    var signedInViewController: SignedInViewController?

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    private let makeOnboardingViewController: () -> OnboardingViewController
    private let makeSignedInViewController: (UserSession) -> SignedInViewController

    // MARK: - Methods
    public init(viewModel: MainViewModel,
                launchViewController: LaunchViewController,
                onboardingViewControllerFactory: @escaping () -> OnboardingViewController,
                signedInViewControllerFactory: @escaping (UserSession) -> SignedInViewController) {
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSignedInViewController = signedInViewControllerFactory
        super.init()
    }

    private func subscribe(on viewPublisher: AnyPublisher<MainView, Never>) {
        viewPublisher.sink { [unowned self] view in self.present(view) }.store(in: &subscriptions)
    }

    private func present(_ view: MainView) {
        switch view {
        case .launching: presentLaunching()
        case .onboarding: presentOnboarding()
        case let .signedIn(userSession: userSession): presentSignedIn(userSession: userSession) }
    }

    private func presentLaunching() {
        viewControllers = [launchViewController]
    }

    private func presentOnboarding() {
        let onboardingViewController = makeOnboardingViewController()
        setViewControllers([onboardingViewController], animated: false)
        self.onboardingViewController = onboardingViewController
    }

    private func presentSignedIn(userSession: UserSession) {
        let signedInViewController = makeSignedInViewController(userSession)
        signedInViewController.modalPresentationStyle = .fullScreen
        present(signedInViewController, animated: true) {
            self.viewControllers = []
            self.onboardingViewController = nil
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        observeViewModel()
    }

    private func observeViewModel() {
        subscribe(on: viewModel.viewPublisher)
    }
}
