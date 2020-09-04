//
//  ProfileViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class ProfileViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: ProfileViewModel


    // MARK: - Methods
    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
