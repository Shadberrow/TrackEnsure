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

public class LaunchViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: LaunchViewModel

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    public init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

}
