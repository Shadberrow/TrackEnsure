//
//  SignedInViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import Combine

public class SignedInViewController: NiblessNavigationController {

    // MARK: - Properties
    // View Model
    let viewModel: SignedInViewModel

    // State
    let userSession: UserSession

    // Child View Controllers
    let profileViewController: ProfileViewController

    // Factories
    let viewControllerFactory: SignedInViewControllerFactory

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(viewModel: SignedInViewModel,
                userSession: UserSession,
                profileViewController: ProfileViewController,
                signedInViewControllerFactory: SignedInViewControllerFactory) {
        self.viewModel = viewModel
        self.userSession = userSession
        self.profileViewController = profileViewController
        self.viewControllerFactory = signedInViewControllerFactory
        super.init()
    }

    public override func loadView() {
        view = SignedInRootView(viewModel: viewModel)
    }

    private func subscribe(on viewPublisher: AnyPublisher<SignedInView, Never>) {
        viewPublisher.sink { [unowned self] view in self.present(view) }.store(in: &subscriptions)
    }

    private func present(_ view: SignedInView) {
        switch view {
        case .home: presentHome()
        case .profile: presentProfile()
        case .addRecord: presentRecordCreation() }
    }

    private func presentHome() {
        let viewController = viewControllerFactory.makeHomeViewController()
        addFullScreen(childViewController: viewController)
    }

    private func presentRecordCreation() {
        let viewController = viewControllerFactory.makeRecordCreationViewController()
        present(viewController, animated: true, completion: nil)
    }

    private func presentProfile() {
        let viewController = viewControllerFactory.makeProfileViewController()
        present(viewController, animated: true, completion: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }

    private func observeViewModel() {
        subscribe(on: viewModel.viewPublisher)
    }
}


public protocol SignedInViewControllerFactory {

    func makeHomeViewController() -> HomeViewController
    func makeProfileViewController() -> ProfileViewController
    func makeRecordCreationViewController() -> RecordCreationViewController
}
