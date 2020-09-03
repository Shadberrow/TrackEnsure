//
//  StatsViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class StatsViewController: NiblessViewController {



    // MARK: - Properties
    let viewModel: RecordsViewModel

    // MARK: - Methods
    public init(viewModel: RecordsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func loadView() {
        view = RecordsRootView(viewModel: viewModel, displayType: .grouped)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
