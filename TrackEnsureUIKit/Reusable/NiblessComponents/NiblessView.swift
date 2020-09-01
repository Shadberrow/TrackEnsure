//
//  NiblessView.swift
//  TrackEnsureUIKit
//
//  Created by Yevhenii on 01.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

open class NiblessView: UIView {

    // MARK: - Methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable,
        message: "Loading this view from a nib is unavailable in favor of initializer dependency injection"
    )
    required public init?(coder: NSCoder) {
        fatalError("Loading this view from a nib is unavailable in favor of initializer dependency injection")
    }
}
