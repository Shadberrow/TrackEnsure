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
    private var childTopAnchorBeginValue: CGFloat = 0

    private let configuration: BottomSheetConfiguration

    // MARK: - State
    public enum BottomSheetState {
        case initial
        case full
    }

    var state: BottomSheetState = .initial

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(viewModel: RecordCreationViewModel,
                recordDetailViewController: RecordDetailViewController) {
        self.viewModel = viewModel
        self.recordDetailViewController = recordDetailViewController
        self.configuration = BottomSheetConfiguration(height: 140, initialOffset: UIScreen.main.bounds.height - 140)
        super.init()
    }

    public override func loadView() {
        view = RecordCreationMapRootView(viewModel: viewModel)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentRecordDetailViewController()
        observeViewModel()
    }

    private func presentRecordDetailViewController() {
        let child = recordDetailViewController
        child.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
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

        view.layoutIfNeeded()
    }

    // MARK: - Configuration
    public struct BottomSheetConfiguration {
        let height: CGFloat
        let initialOffset: CGFloat
    }

    // MARK: - Bottom Sheet Actions
    public func showBottomSheet(animated: Bool = true) {
        self.childTopAnchor.constant = -configuration.height

        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.state = .full
            })
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }

    public func hideBottomSheet(animated: Bool = true) {
        view.endEditing(true)
        self.childTopAnchor.constant = -configuration.initialOffset

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in self.state = .initial })
        } else {
            self.view.layoutIfNeeded()
            self.state = .initial
        }
    }

    private func observeViewModel() {
        viewModel.dismissPublisher.sink { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.store(in: &subscriptions)

        viewModel.isDetailSheetOpenSubject.sink { [weak self] in
            $0 ? self?.showBottomSheet() : self?.hideBottomSheet()
        }.store(in: &subscriptions)
    }

    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {

        guard (viewModel.locationSubject.value != nil) else { return }

        let translation = sender.translation(in: recordDetailViewController.view)
        let velocity = sender.velocity(in: recordDetailViewController.view)
        let yTranslationMagnitude = translation.y.magnitude

        switch sender.state {
        case .began, .changed:
            if self.state == .full {
                childTopAnchor.constant = translation.y > 0 ? -(configuration.height + yTranslationMagnitude/2) : -(configuration.height - yTranslationMagnitude/3)
                self.view.layoutIfNeeded()
            } else {
                childTopAnchor.constant = translation.y > 0 ? -(configuration.initialOffset + yTranslationMagnitude/3) : -(configuration.initialOffset - yTranslationMagnitude)
                self.view.layoutIfNeeded()
            }
        case .ended:
            if self.state == .full {
                yTranslationMagnitude <= configuration.height || velocity.y < 1000 ? showBottomSheet() : hideBottomSheet()
            } else {
                yTranslationMagnitude >= configuration.height || velocity.y < -1000 ? showBottomSheet() : hideBottomSheet()
            }
        case .failed:
            state == .full ? showBottomSheet() : hideBottomSheet()
        default: break
        }
    }
}
