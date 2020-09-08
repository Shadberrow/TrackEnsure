//
//  HomeRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit

public class HomeRootView: NiblessView, UIScrollViewDelegate {

    // MARK: - Properties
    // ViewModel
    let viewModel: HomeViewModel

    // Subviews
    private var scrollView: UIScrollView!
    private var contentStack: UIStackView!

    private var headerContainer: UIView!
    private var headerTitle: UILabel!
    private var pageIndicator: UIView!
    private var segmentContainer: UIStackView!
    private var recordButton: UIButton!
    private var statsButton: UIButton!

    private var footerContainerView: UIView!
    private var actionAddButton: UIButton!
    private var actionSignOutButton: UIButton!

    private var pageIndicatorLeadingAnchor: NSLayoutConstraint!

    // Child View Controllers
    let recordsView: UIView
    let statsView: UIView

    private var hierarchyNotReady: Bool = true

    // MARK: - Methods
    public init(viewModel: HomeViewModel,
                recordsView: UIView,
                statsView: UIView) {
        self.viewModel = viewModel
        self.recordsView = recordsView
        self.statsView = statsView
        super.init(frame: .zero)
    }

    deinit { print("DEINIT: ", String(describing: self)) }

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false

        isUserInteractionEnabled = true
    }

    private func setupSubviews() {
        backgroundColor = .systemBackground

        scrollView = MyScrollView()
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.canCancelContentTouches = false
        scrollView.delaysContentTouches = true

        contentStack = UIStackView(arrangedSubviews: [recordsView, statsView])
        contentStack.axis = .horizontal
        contentStack.distribution = .fillEqually

        headerContainer = UIView()
        headerContainer.backgroundColor = .secondarySystemBackground

        pageIndicator = UIView()
        pageIndicator.backgroundColor = .black
        pageIndicator.layer.cornerRadius = 2

        headerTitle = UILabel()
        headerTitle.text = "Home"
        headerTitle.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        headerTitle.textAlignment = .center
        headerTitle.textColor = .label

        recordButton = UIButton(type: .system)
        recordButton.setTitle("Records", for: .normal)
        recordButton.backgroundColor = .tertiarySystemBackground
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        recordButton.tintColor = .label
        recordButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)

        statsButton = UIButton(type: .system)
        statsButton.setTitle("Stats", for: .normal)
        statsButton.backgroundColor = .tertiarySystemBackground
        statsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        statsButton.tintColor = .label
        statsButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)

        segmentContainer = UIStackView(arrangedSubviews: [recordButton, statsButton])
        segmentContainer.axis = .horizontal
        segmentContainer.distribution = .fillEqually

        footerContainerView = UIView()
        footerContainerView.backgroundColor = .secondarySystemBackground

        actionAddButton = UIButton(type: .system)
        actionAddButton.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)), for: .normal)
        actionAddButton.tintColor = .label
        actionAddButton.addTarget(self, action: #selector(handleAddAction), for: .touchUpInside)

        actionSignOutButton = UIButton(type: .system)
        actionSignOutButton.setImage(UIImage(systemName: "arrowshape.turn.up.left.2", withConfiguration: UIImage.SymbolConfiguration(textStyle: .title2)), for: .normal)
        actionSignOutButton.tintColor = .label
        actionSignOutButton.addTarget(self, action: #selector(handleActionSignOut), for: .touchUpInside)
    }

    private func constructHierarchy() {
        addSubview(headerContainer)
        headerContainer.addSubview(headerTitle)
        headerContainer.addSubview(segmentContainer)
        headerContainer.addSubview(pageIndicator)
        addSubview(scrollView)
        scrollView.addSubview(contentStack)
        addSubview(footerContainerView)
        footerContainerView.addSubview(actionAddButton)
        footerContainerView.addSubview(actionSignOutButton)
    }

    private func activateConstraints() {
        activateConstraintsHeaderContainerView()
        activateConstraintsPageIndicator()
        activateConstraintsSegmentContainer()
        activateConstraintsHeaderTitle()
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsFooterView()
        activateConstraintsactionAddButton()
        activateConstraintsActionSignOutButton()
    }

    private func activateConstraintsHeaderContainerView() {
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        let leading = headerContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = headerContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = headerContainer.topAnchor.constraint(equalTo: self.topAnchor)
        let height = headerContainer.heightAnchor.constraint(equalToConstant: 97 + (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
        NSLayoutConstraint.activate([leading, trailing, top, height])
    }

    private func activateConstraintsPageIndicator() {
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorLeadingAnchor = pageIndicator.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        pageIndicatorLeadingAnchor.priority = UILayoutPriority(160)
        let trailing = pageIndicator.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        trailing.priority = UILayoutPriority(150)
        let bottom = pageIndicator.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        let height = pageIndicator.heightAnchor.constraint(equalToConstant: 4)
        let width = pageIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        width.priority = UILayoutPriority(170)
        NSLayoutConstraint.activate([pageIndicatorLeadingAnchor, trailing, bottom, height, width])
    }

    private func activateConstraintsSegmentContainer() {
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        let leading = segmentContainer.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        let trailing = segmentContainer.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        let bottom = segmentContainer.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        let height = segmentContainer.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }

    private func activateConstraintsHeaderTitle() {
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        let leading = headerTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        let trailing = headerTitle.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        let top = headerTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
        let bottom = headerTitle.bottomAnchor.constraint(equalTo: segmentContainer.topAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: footerContainerView.topAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    private func activateConstraintsContentView() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        let top = contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let bottom = contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let leading = contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let centerY = contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let width = contentStack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2)
        NSLayoutConstraint.activate([top, bottom, leading, trailing, centerY, width])
    }

    private func activateConstraintsFooterView() {
        footerContainerView.translatesAutoresizingMaskIntoConstraints = false
        let leading = footerContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = footerContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = footerContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let height = footerContainerView.heightAnchor.constraint(equalToConstant: 49 + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0))
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }

    private func activateConstraintsactionAddButton() {
        actionAddButton.translatesAutoresizingMaskIntoConstraints = false
        let width = actionAddButton.widthAnchor.constraint(equalToConstant: 45)
        let height = actionAddButton.heightAnchor.constraint(equalTo: actionAddButton.widthAnchor)
        let trailing = actionAddButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8)
        let top = actionAddButton.topAnchor.constraint(equalTo: footerContainerView.topAnchor, constant: 8)
        NSLayoutConstraint.activate([width, height, trailing, top])
    }

    private func activateConstraintsActionSignOutButton() {
        actionSignOutButton.translatesAutoresizingMaskIntoConstraints = false
        let width = actionSignOutButton.widthAnchor.constraint(equalToConstant: 45)
        let height = actionSignOutButton.heightAnchor.constraint(equalTo: actionAddButton.widthAnchor)
        let leading = actionSignOutButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        let top = actionSignOutButton.topAnchor.constraint(equalTo: footerContainerView.topAnchor, constant: 8)
        NSLayoutConstraint.activate([width, height, leading, top])
    }

    @objc private func handleAddAction() {
        viewModel.handleAddAction()
    }

    @objc private func handleActionSignOut() {
        viewModel.signOut()
    }

    @objc private func handleAciton(_ sender: UIButton) {
        if sender == recordButton {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        } else if sender == statsButton {
            scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: true)
        }
    }

    // MARK: - Scroll View Delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        pageIndicatorLeadingAnchor.constant = x/2
    }
}


class MyScrollView: UIScrollView {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let superview = superview else { return false }
        let pos = gestureRecognizer.location(in: superview)
        return pos.x < frame.width * 0.15 || pos.x > frame.width * 0.85 ? false : true
    }
}
