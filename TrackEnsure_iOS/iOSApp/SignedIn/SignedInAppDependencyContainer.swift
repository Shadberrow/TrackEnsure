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
    let mainViewModel: MainViewModel

    // Context
    let userSession: UserSession
    let signedInViewModel: SignedInViewModel
    let sharedRecordsDataStore: RecordsDataStore
    let firebaseDataStore: FirebaseRecordsDataStore

    // MARK: - Methods

    public init(userSession: UserSession, appDependencyContainer: AppDependencyContainer) {
        func makeRecordsDataStore() -> RecordsDataStore {
//            return FakeRecordsDataStore()
            return RealmRecordsDataStore(userProfile: userSession.profile)
        }

        func makeFirebaseDataStore() -> FirebaseRecordsDataStore {
            return FirebaseRecordsDataStore(userSession: userSession.remoteSession)
        }

        self.userSession = userSession
        self.userSessionRepository = appDependencyContainer.sharedUserSessionRepository
        self.mainViewModel = appDependencyContainer.sharedMainViewModel

        self.sharedRecordsDataStore = makeRecordsDataStore()
        self.firebaseDataStore = makeFirebaseDataStore()
        self.signedInViewModel = SignedInViewModel(recordsDataStore: sharedRecordsDataStore, firebaseDataStore: self.firebaseDataStore)
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
        return HomeViewModel(userSession: userSession,
                             createRecordResponder: signedInViewModel,
                             notSignedInResponder: mainViewModel,
                             userSessionRepository: userSessionRepository)
    }

    public func makeStatsViewController() -> StatsViewController {
        return StatsViewController(viewModel: signedInViewModel)
    }

    public func makeRecordsViewController() -> RecordsViewController {
        return RecordsViewController(viewModel: signedInViewModel)
    }

    // Record Creation

    public func makeRecordCreationViewController() -> RecordCreationViewController {
        let viewModel = makeRecordCreationViewModel()
        let recordDetailViewController = makeRecordDetailViewController(viewModel: viewModel)
        return RecordCreationViewController(viewModel: viewModel,
                                            recordDetailViewController: recordDetailViewController)
    }

    public func makeRecordEditionViewController(recordToEdit: GasRefill) -> RecordCreationViewController {
        let viewModel = makeRecordCreationViewModel(recordToEdit: recordToEdit)
        let recordDetailViewController = makeRecordDetailViewController(viewModel: viewModel)
        return RecordCreationViewController(viewModel: viewModel,
                                            recordDetailViewController: recordDetailViewController)
    }

    private func makeRecordCreationViewModel(recordToEdit: GasRefill? = nil) -> RecordCreationViewModel {
        return RecordCreationViewModel(signedInViewModel: signedInViewModel,
                                       recordsDataStore: sharedRecordsDataStore,
                                       record: recordToEdit)
    }

    private func makeRecordDetailViewController(viewModel: RecordCreationViewModel) -> RecordDetailViewController {
        return RecordDetailViewController(viewModel: viewModel)
    }
}

extension SignedInAppDependencyContainer: SignedInViewControllerFactory { }
