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
    public let addressSubject = CurrentValueSubject<String?, Never>("Select address")


    public let supplierSubject = CurrentValueSubject<String, Never>("")
    public let typeSubject = CurrentValueSubject<String, Never>("")
    public let amountSubject = CurrentValueSubject<String, Never>("")
    public let priceSubject = CurrentValueSubject<String, Never>("")

    public var isButtonEnabled: AnyPublisher<Bool, Never> { return isButtonEnabledSubject.eraseToAnyPublisher() }
    let isButtonEnabledSubject = CurrentValueSubject<Bool, Never>(false)

    public var dismissPublisher: AnyPublisher<Void, Never> { return dismissSubject.eraseToAnyPublisher() }
    let dismissSubject = PassthroughSubject<Void, Never>()

    public let isDetailSheetOpenSubject = CurrentValueSubject<Bool, Never>(false)

    // Combine
    private var subscriptions = Set<AnyCancellable>()

    let signedInViewModel: SignedInViewModel
    let recordsDataStore: RecordsDataStore

    var recordToUpdate: GasRefill?

    // MARK: - Methods
    public init(signedInViewModel: SignedInViewModel,
                recordsDataStore: RecordsDataStore,
                record: GasRefill? = nil) {
        self.signedInViewModel = signedInViewModel
        self.recordsDataStore = recordsDataStore

        self.locationSubject.map({ $0 != nil }).subscribe(isButtonEnabledSubject).store(in: &subscriptions)

        guard let record = record else { return }
        recordToUpdate = record

        addressSubject.send(record.addressString)
        locationSubject.send(record.address)
        supplierSubject.send(record.gas.provider)
        typeSubject.send(record.gas.type)
        amountSubject.send("\(Int(record.amount))")
        priceSubject.send("\(Int(record.price))")
        isButtonEnabledSubject.send(true)

        expandDetailView()
    }

    public func expandDetailView() {
        isDetailSheetOpenSubject.send(true)
    }

    public func dismissCreation() {
        dismissSubject.send(())
    }

    public func finishRecordCreation() {
        let quantity = amountSubject.compactMap { Double($0) }.share()
        let price = priceSubject.compactMap { Double($0) }.share()
        let gas = supplierSubject.combineLatest(typeSubject).map { Gas(provider: $0, type: $1) }

        let uuid: String
        let date: Date
        if let oldRecord = recordToUpdate {
            uuid = oldRecord.uuid
            date = oldRecord.createdAt
        } else {
            uuid = UUID().uuidString
            date = Date()
        }

        _ = locationSubject.compactMap({ $0 }).combineLatest(gas, quantity, price)
            .map({ [unowned self] in
                GasRefill(address: $0, addressString: self.addressSubject.value ?? "", gas: $1, amount: $2, price: $3, createdAt: date, uuid: uuid) })
            .sink(receiveValue: { [unowned self] in self.handleNewRecord($0) })
    }

    private func handleNewRecord(_ record: GasRefill) {
        if let oldRecord = recordToUpdate {
            self.recordsDataStore.updateRecord(record: record) { [unowned self] result in
                switch result {
                case let .success(record):
                    self.signedInViewModel.updateRecord(record, oldRecord: oldRecord)
                    self.dismissCreation()
                case let .failure(error): print(error)
                }
            }
        } else {
            self.recordsDataStore.createRecord(record: record) { [unowned self] result in
                switch result {
                case let .success(record):
                    self.signedInViewModel.addRecord(record)
                    self.dismissCreation()
                case let .failure(error): print(error)
                }
            }
        }
    }
}
