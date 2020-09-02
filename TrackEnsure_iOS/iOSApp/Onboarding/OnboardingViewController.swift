//
//  OnboardingViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class OnboardingViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: OnboardingViewModel

    // MARK: - Methods
    public init(viewModelFactory: OnboardingViewModelFactory) {
        self.viewModel = viewModelFactory.makeOnboardingViewModel()
        super.init()
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public override func loadView() {
        view = OnboardingRootView(viewModel: viewModel)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}


public protocol OnboardingViewModelFactory {

    func makeOnboardingViewModel() -> OnboardingViewModel
}
