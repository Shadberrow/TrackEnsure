//
//  SignedInAppDependencyContainer.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit

public class SignedInAppDependencyContainer {

    // MARK: - Properties

    // Long-lived dependencies
    let userSessionRepository: UserSessionRepository

    // Context
    let userSession: UserSession
    let sharedRecordsDataStore: RecordsDataStore

    // MARK: - Methods

    public init(userSession: UserSession, appDependencyContainer: AppDependencyContainer) {

        func makeRecordsDataStore() -> RecordsDataStore {
            return FakeRecordsDataStore()
        }

        self.userSession = userSession
        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository

        self.sharedRecordsDataStore = makeRecordsDataStore()
    }

    // Signed-in

    public func makeSignedInViewController() -> SignedInViewController {
        let viewModel = makeSignedInViewModel()
        let profileViewController = makeProfileViewController()
        return SignedInViewController(viewModel: viewModel,
                                      userSession: userSession,
                                      profileViewController: profileViewController,
                                      signedInViewControllerFactory: self)
    }

    public func makeSignedInViewModel() -> SignedInViewModel {
        return SignedInViewModel()
    }

    // Profile

    public func makeProfileViewController() -> ProfileViewController {
        let viewModel = makeProfileViewModel()
        return ProfileViewController(viewModel: viewModel)
    }

    private func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel()
    }

    // Home

    public func makeHomeViewController() -> HomeViewController {
        let viewModel = makeHomeViewModel()
        let recordsViewController = makeRecordsViewController()
        let statsViewController = makeStatsViewController()
        return HomeViewController(viewModel: viewModel,
                                  recordsViewController: recordsViewController,
                                  statsViewController: statsViewController)
    }

    public func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel()
    }

    public func makeStatsViewController() -> StatsViewController {
        return StatsViewController()
    }

    public func makeRecordsViewController() -> RecordsViewController {
        return RecordsViewController()
    }

}

extension SignedInAppDependencyContainer: SignedInViewControllerFactory { }
