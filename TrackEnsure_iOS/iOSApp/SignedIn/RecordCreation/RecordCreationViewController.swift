//
//  RecordCreationViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit
import Combine

public class RecordCreationViewController: NiblessNavigationController {

    // MARK: - Properties
    // View Model
    let viewModel: RecordCreationViewModel

    // Child Controller
    let recordDetailViewController: RecordDetailViewController

    private var childTopAnchor: NSLayoutConstraint!

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(viewModel: RecordCreationViewModel,
                recordDetailViewController: RecordDetailViewController) {
        self.viewModel = viewModel
        self.recordDetailViewController = recordDetailViewController
        super.init()
    }

    public override func loadView() {
        view = RecordCreationMapRootView(viewModel: viewModel)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentRecordDetailViewController()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        childTopAnchor.constant = -view.bounds.maxY + 140
        animateLayoutSubviews()
    }

    private func presentRecordDetailViewController() {
        let child = recordDetailViewController
        guard child.parent == nil else { return }

        addChild(child)
        view.addSubview(child.view)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        let leading = view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor)
        childTopAnchor = view.topAnchor.constraint(equalTo: child.view.topAnchor, constant: -view.bounds.maxY)
        let height = view.heightAnchor.constraint(equalTo: child.view.heightAnchor)
        let constraints = [leading, trailing, childTopAnchor!, height]
        NSLayoutConstraint.activate(constraints)
        view.addConstraints(constraints)

        child.didMove(toParent: self)
    }

    private func expandRecordDetailView() {
        childTopAnchor.constant = -120
        animateLayoutSubviews()
    }

    private func animateLayoutSubviews() {
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func observeViewModel() {
        viewModel.dismissPublisher.sink { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.store(in: &subscriptions)

        viewModel.expandPublisher.sink { [weak self] in
            self?.expandRecordDetailView()
        }.store(in: &subscriptions)
    }
}
