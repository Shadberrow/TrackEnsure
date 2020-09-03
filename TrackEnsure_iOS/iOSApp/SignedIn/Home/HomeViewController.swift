//
//  HomeViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class HomeViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: HomeViewModel

    // Child Controllers
    let recordsViewController: RecordsViewController
    let statsViewController: StatsViewController

    // MARK: - Methods
    public init(viewModel: HomeViewModel,
                recordsViewController: RecordsViewController,
                statsViewController: StatsViewController) {
        self.viewModel = viewModel
        self.recordsViewController = recordsViewController
        self.statsViewController = statsViewController
        super.init()
    }

    public override func loadView() {
        view = HomeRootView(viewModel: viewModel,
                            recordsView: recordsViewController.view,
                            statsView: statsViewController.view)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

}
