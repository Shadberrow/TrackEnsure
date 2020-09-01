//
//  MainViewController.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import TrackEnsureUIKit
import TrackEnsureKit
import Combine

public class MainViewController: NiblessViewController {

    // MARK: - Properties
    // View Model
    let viewModel: MainViewModel

    // Child View Controller
    let launchViewController: LaunchViewController

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Methods
    public init(viewModel: MainViewModel,
                launchViewController: LaunchViewController) {
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        super.init()
    }

    private func subscribe(on viewPublisher: AnyPublisher<MainView, Never>) {
        viewPublisher.sink { [unowned self] view in self.present(view) }.store(in: &subscriptions)
    }

    private func present(_ view: MainView) {
        switch view {
        case .launching: presentLaunching()
        case .onboarding: presentOnboarding()
        case let .signedIn(userSession: userSession): presentSignedIn(userSession: userSession) }
    }

    private func presentLaunching() {
        print(#line, #function, #file)
        launchViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(self.launchViewController, animated: false)
        }
    }

    private func presentOnboarding() {
        print(#line, #function, #file)
    }

    private func presentSignedIn(userSession: UserSession) {
        print(#line, #function, #file)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }

    private func observeViewModel() {
        subscribe(on: viewModel.viewPublisher)
    }

}
