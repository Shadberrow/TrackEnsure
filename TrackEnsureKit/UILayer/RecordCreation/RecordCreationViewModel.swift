//
//  RecordCreationViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Combine

public class RecordCreationViewModel {

    // MARK: - Properties
    public var addressLabel: AnyPublisher<String?, Never> { return addressSubject.eraseToAnyPublisher() }
    public let locationSubject = CurrentValueSubject<Location?, Never>(nil)
    public let addressSubject = CurrentValueSubject<String?, Never>(nil)

    public var dismissPublisher: AnyPublisher<Void, Never> { return dismissSubject.eraseToAnyPublisher() }
    let dismissSubject = PassthroughSubject<Void, Never>()

    public var expandPublisher: AnyPublisher<Void, Never> { return expandSubject.eraseToAnyPublisher() }
    let expandSubject = PassthroughSubject<Void, Never>()

    // MARK: - Methods
    public init() {
        
    }

    public func expandDetailView() {
        expandSubject.send(())
    }

    public func dismissCreation() {
        dismissSubject.send(())
    }
}
