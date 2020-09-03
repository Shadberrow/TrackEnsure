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
    let signedInViewModel: SignedInViewModel
    let sharedRecordsDataStore: RecordsDataStore

    // MARK: - Methods

    public init(userSession: UserSession, appDependencyContainer: AppDependencyContainer) {
        func makeSignedInViewModel() -> SignedInViewModel {
            return SignedInViewModel()
        }

        func makeRecordsDataStore() -> RecordsDataStore {
            return FakeRecordsDataStore()
        }

        self.userSession = userSession
        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository

        self.signedInViewModel = makeSignedInViewModel()
        self.sharedRecordsDataStore = makeRecordsDataStore()
    }

    // Signed-in

    public func makeSignedInViewController() -> SignedInViewController {
        let profileViewController = makeProfileViewController()
        return SignedInViewController(viewModel: signedInViewModel,
                                      userSession: userSession,
                                      profileViewController: profileViewController,
                                      signedInViewControllerFactory: self)
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
        return HomeViewModel(createRecordResponder: signedInViewModel)
    }

    public func makeStatsViewController() -> StatsViewController {
        let viewModel = makeRecordsViewModel()
        return StatsViewController(viewModel: viewModel)
    }

    public func makeRecordsViewController() -> RecordsViewController {
        let viewModel = makeRecordsViewModel()
        return RecordsViewController(viewModel: viewModel)
    }

    public func makeRecordsViewModel() -> RecordsViewModel {
        return RecordsViewModel(recordsDataStore: sharedRecordsDataStore)
    }

    // Record Creation

    public func makeRecordCreationViewController() -> RecordCreationViewController {
        let viewModel = makeRecordCreationViewModel()
        let recordDetailViewController = makeRecordDetailViewController(viewModel: viewModel)
        return RecordCreationViewController(viewModel: viewModel, recordDetailViewController: recordDetailViewController)
    }

    private func makeRecordCreationViewModel() -> RecordCreationViewModel {
        return RecordCreationViewModel()
    }

    private func makeRecordDetailViewController(viewModel: RecordCreationViewModel) -> RecordDetailViewController {
        return RecordDetailViewController(viewModel: viewModel)
    }
}

extension SignedInAppDependencyContainer: SignedInViewControllerFactory { }
