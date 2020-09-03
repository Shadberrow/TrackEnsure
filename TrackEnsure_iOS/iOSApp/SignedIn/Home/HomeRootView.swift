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
    private var contentView: UIStackView!

    private var headerContainer: UIView!
    private var headerTitle: UILabel!
    private var pageIndicator: UIView!
    private var segmentContainer: UIStackView!
    private var recordButton: UIButton!
    private var statsButton: UIButton!

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
    }

    private func setupSubviews() {
        backgroundColor = .secondarySystemBackground

        scrollView = UIScrollView()
        scrollView.backgroundColor = .systemPurple
//        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false

        contentView = UIStackView(arrangedSubviews: [recordsView, statsView])
        contentView.axis = .horizontal
        contentView.distribution = .fillEqually

        headerContainer = UIView()
        headerContainer.backgroundColor = .secondarySystemBackground

        pageIndicator = UIView()
        pageIndicator.backgroundColor = .separator

        headerTitle = UILabel()
        headerTitle.text = "Home"
        headerTitle.font = UIFont.preferredFont(forTextStyle: .title2)
        headerTitle.textAlignment = .center
        headerTitle.textColor = .label

        recordButton = UIButton(type: .system)
        recordButton.setTitle("Records", for: .normal)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        recordButton.tintColor = .label
//        recordButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)

        statsButton = UIButton(type: .system)
        statsButton.setTitle("Stats", for: .normal)
        statsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        statsButton.tintColor = .label
//        statsButton.addTarget(self, action: #selector(handleAciton), for: .touchUpInside)

        segmentContainer = UIStackView(arrangedSubviews: [recordButton, statsButton])
        segmentContainer.axis = .horizontal
        segmentContainer.distribution = .fillEqually
    }

    private func constructHierarchy() {
        addSubview(headerContainer)
        headerContainer.addSubview(headerTitle)
        headerContainer.addSubview(segmentContainer)
        headerContainer.addSubview(pageIndicator)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func activateConstraints() {
        activateConstraintsHeaderContainerView()
        activateConstraintsPageIndicator()
        activateConstraintsSegmentContainer()
        activateConstraintsHeaderTitle()
        activateConstraintsScrollView()
        activateConstraintsContentView()
    }

    private func activateConstraintsHeaderContainerView() {
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        let leading = headerContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = headerContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = headerContainer.topAnchor.constraint(equalTo: self.topAnchor)
        let height = headerContainer.heightAnchor.constraint(equalToConstant: 30 + self.safeAreaInsets.top)
        NSLayoutConstraint.activate([leading, trailing, top, height])
    }

    private func activateConstraintsPageIndicator() {
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorLeadingAnchor = pageIndicator.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        pageIndicatorLeadingAnchor.priority = UILayoutPriority(160)
        let trailing = pageIndicator.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        trailing.priority = UILayoutPriority(150)
        let bottom = pageIndicator.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        let height = pageIndicator.heightAnchor.constraint(equalToConstant: 3)
        let width = pageIndicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        width.priority = UILayoutPriority(170)
        NSLayoutConstraint.activate([pageIndicatorLeadingAnchor, trailing, bottom, height, width])
    }

    private func activateConstraintsSegmentContainer() {
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        let leading = segmentContainer.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        let trailing = segmentContainer.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        let bottom = segmentContainer.bottomAnchor.constraint(equalTo: pageIndicator.topAnchor)
        let height = segmentContainer.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }

    private func activateConstraintsHeaderTitle() {
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        let leading = headerTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor)
        let trailing = headerTitle.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor)
        let bottom = headerTitle.bottomAnchor.constraint(equalTo: segmentContainer.topAnchor)
        NSLayoutConstraint.activate([leading, trailing, bottom])
    }

    private func activateConstraintsScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let leading = scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let top = scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        let bottom = scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        NSLayoutConstraint.activate([leading, trailing, top, bottom])
    }

    private func activateConstraintsContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let top = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
        let bottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        let leading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
        let trailing = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        let centerY = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        let width = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 2)
        NSLayoutConstraint.activate([top, bottom, leading, trailing, centerY, width])
    }

    // MARK: - Scroll View Delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        pageIndicatorLeadingAnchor.constant = x/2
    }
}
