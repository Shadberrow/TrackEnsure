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
    public let addressSubject = CurrentValueSubject<String?, Never>("Move pin to select location")

    public let supplierSubject = CurrentValueSubject<String, Never>("")
    public let typeSubject = CurrentValueSubject<String, Never>("")
    public let amountSubject = CurrentValueSubject<String, Never>("")
    public let priceSubject = CurrentValueSubject<String, Never>("")

    public var dismissPublisher: AnyPublisher<Void, Never> { return dismissSubject.eraseToAnyPublisher() }
    let dismissSubject = PassthroughSubject<Void, Never>()

    public var expandPublisher: AnyPublisher<Void, Never> { return expandSubject.eraseToAnyPublisher() }
    let expandSubject = PassthroughSubject<Void, Never>()

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    let recordsDataStore: RecordsDataStore

    // MARK: - Methods
    public init(recordsDataStore: RecordsDataStore) {
        self.recordsDataStore = recordsDataStore
    }

    public func expandDetailView() {
        expandSubject.send(())
    }

    public func dismissCreation() {
        dismissSubject.send(())
    }

    public func finishRecordCreation() {
        let quantityInt = amountSubject.map { $0.components(separatedBy:CharacterSet.decimalDigits.inverted).joined() }.compactMap { Double($0) }.share()
        let priceInt = priceSubject.map { $0.components(separatedBy:CharacterSet.decimalDigits.inverted).joined() }.compactMap { Double($0) }.share()
        let gas = supplierSubject.combineLatest(typeSubject).map { Gas(provider: $0, type: $1) }

        _ = locationSubject.compactMap({ $0 }).combineLatest(gas, quantityInt, priceInt)
            .map({ [unowned self] in GasRefill(address: $0, addressString: self.addressSubject.value ?? "", gas: $1, amount: $2, price: $3, createdAt: Date(), uuid: UUID()) })
            .map({ [unowned self] in self.recordsDataStore.createRecord(record: $0) })
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { [unowned self] in self.dismissCreation() })
    }
}
