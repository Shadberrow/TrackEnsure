//
//  TEAppDependencyContainer.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import TrackEnsureKit

public class AppDependencyContainer {

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
//            return FakeUserSessionDataStore(hasToken: true)
            return DiskUserSessionDataStore()
        }

        func makeAuthRemoteApi() -> AuthRemoteApi {
//            return FakeAuthRemoteApi()
            return FirebaseAuthRemoteApi()
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

        let signedInViewControllerFactory = { [unowned self] (userSession: UserSession) in
            return self.makeSignedInViewController(session: userSession)
        }

        return MainViewController(viewModel: sharedMainViewModel,
                                  launchViewController: launchViewController,
                                  onboardingViewControllerFactory: onboardingViewControllerFactory,
                                  signedInViewControllerFactory: signedInViewControllerFactory)
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

    public func makeSignedInViewController(session: UserSession) -> SignedInViewController {
        let dependencyContainer = makeSignedInDependencyContainer(session: session)
        return dependencyContainer.makeSignedInViewController()
    }

    public func makeSignedInDependencyContainer(session: UserSession) -> SignedInAppDependencyContainer {
        return SignedInAppDependencyContainer(userSession: session, appDependencyContainer: self)
    }
}

extension AppDependencyContainer: LaunchViewModelFactory, OnboardingViewModelFactory { }
