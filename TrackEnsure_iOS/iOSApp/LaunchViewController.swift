//
//  LaunchViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import Combine
import Foundation

public class LaunchViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: LaunchViewModel

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    public init(viewModelFactory: LaunchViewModelFactory) {
        self.viewModel = viewModelFactory.makeLaunchViewModel()
        super.init()
    }

    public override func loadView() {
        view = LaunchRootView(viewModel: viewModel)
    }
}


public protocol LaunchViewModelFactory {

    func makeLaunchViewModel() -> LaunchViewModel
}
