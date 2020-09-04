//
//  RecordsViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit

public class RecordsViewController: NiblessViewController {

    // MARK: - Properties
    let viewModel: RecordsViewModel

    // MARK: - Methods
    public init(viewModel: RecordsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    public override func loadView() {
        view = RecordsRootView(viewModel: viewModel, displayType: .normal)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadRecords()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
