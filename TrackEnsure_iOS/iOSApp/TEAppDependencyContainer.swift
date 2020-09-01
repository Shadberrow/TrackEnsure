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
    let sharedMainViewModel: MainViewModel

    // MARK: - Methods
    public init() {

        func makeMainViewModel() -> MainViewModel {
            return MainViewModel()
        }

        self.sharedMainViewModel = makeMainViewModel()
    }

    public func makeMainViewController() -> UINavigationController {
        return undefined()
    }
}
