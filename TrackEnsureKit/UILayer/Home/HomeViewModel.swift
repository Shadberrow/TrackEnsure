//
//  HomeViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

public class HomeViewModel {

    // MARK: - Properties
    let createRecordResponder: CreateRecordResponder

    // MARK: - Methods
    public init(createRecordResponder: CreateRecordResponder) {
        self.createRecordResponder = createRecordResponder
    }

    public func handleAddAction() {
        createRecordResponder.goToRecordCreation()
    }

}
