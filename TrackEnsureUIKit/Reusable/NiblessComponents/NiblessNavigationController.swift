//
//  NiblessNavigationController.swift
//  TrackEnsureUIKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

open class NiblessNavigationController: UINavigationController {

    // MARK: - Methods
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable,
        message: "Loading this view from a nib is unavailable in favor of initializer dependency injection"
    )
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
        message: "Loading this view from a nib is unavailable in favor of initializer dependency injection"
    )
    required public init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unavailable in favor of initializer dependency injection")
    }
}
