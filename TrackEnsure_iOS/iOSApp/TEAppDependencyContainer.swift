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
            return FakeUserSessionDataStore(hasToken: true)
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

    public func makeMainViewController() -> UINavigationController {
        return undefined()
    }
}
