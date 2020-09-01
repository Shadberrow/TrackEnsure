//
//  TEAppDependencyContainer.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import TrackEnsureKit

public class TEAppDependencyContainer {

    // MARK: - Properties

    // Long-lived dependencies
    let sharedUserSessionRepository: UserSessionRepository
    let sharedMainViewModel: MainViewModel

    // MARK: - Methods
    public init() {
        func makeUserSessionRepository() -> UserSessionRepository {
            let dataStore = makeUserSessionDataStore()
            let remoteApi = makeAuthRemoteApi()
            return TEUserSessionRepository(dataStore: dataStore, remoteApi: remoteApi)
        }

        func makeUserSessionDataStore() -> UserSessionDataStore {
            return FakeUserSessionDataStore(hasToken: false)
        }

        func makeAuthRemoteApi() -> AuthRemoteApi {
            return FakeAuthRemoteApi()
        }

        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }

        self.sharedUserSessionRepository = makeUserSessionRepository()
        self.sharedMainViewModel = makeMainViewModel()
    }

    // Main
    // Funcitons to create MainViewController

    public func makeMainViewController() -> MainViewController {
        let launchViewController = makeLaunchViewController()

        let onboardingViewControllerFactory = { [unowned self] in
            return self.makeOnboardingViewController()
        }

        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory)
    }

    // Launching

    public func makeLaunchViewController() -> LaunchViewController {
        return LaunchViewController(viewModelFactory: self)
    }

    public func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(userSessionRepository: sharedUserSessionRepository,
                               notSignedInResponder: sharedMainViewModel,
                               signedInResponder: sharedMainViewModel)
    }

    // Onboarding

    public func makeOnboardingViewController() -> OnboardingViewController {
        return OnboardingViewController(viewModelFactory: self)
    }

    public func makeOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(userSessionRepository: sharedUserSessionRepository,
                                   signedInResponder: sharedMainViewModel)
    }

    // Signed-in

}

extension TEAppDependencyContainer: LaunchViewModelFactory, OnboardingViewModelFactory { }
