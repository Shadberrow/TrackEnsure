//
//  SignedInViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 02.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine

public enum RecordsDisplayType {
    case normal, grouped
}

public class SignedInViewModel: CreateRecordResponder {

    // MARK: - Properties
    // Combine
    public var viewPublisher: AnyPublisher<SignedInView, Never> { return viewSubject.eraseToAnyPublisher() }
    private let viewSubject = CurrentValueSubject<SignedInView, Never>(.home)
    public let tableViewReloadSubject = PassthroughSubject<Void, Never>()

    let recordsDataStore: RecordsDataStore
    let firebaseDataStore: FirebaseRecordsDataStore?
    private var defaultRecords: [RecordCellViewModel] = []
    private var groupedRecords: [RecordCellViewModel] = []
    private var records: [GasRefill] = [] {
        didSet { updateData() }
    }

    // MARK: - Methods
    public init(recordsDataStore: RecordsDataStore,
                firebaseDataStore: FirebaseRecordsDataStore?) {
        self.recordsDataStore = recordsDataStore
        self.firebaseDataStore = firebaseDataStore
        self.loadRecords()
    }

    public func presentProfileScreen() {
        viewSubject.send(.profile)
    }

    public func goToRecordCreation() {
        viewSubject.send(.addRecord)
    }

    public func loadRecords() {
        switch recordsDataStore.getAllRecords() {
        case let .success(records): self.records = records
        case let .failure(error): print(error) }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int, displayType: RecordsDisplayType) -> Int {
        switch displayType {
        case .normal: return defaultRecords.count
        case .grouped: return groupedRecords.count }
    }

    public func tableView(setupCell cell: UITableViewCell, forRowAt indexPath: IndexPath, displayType: RecordsDisplayType) {
        let viewModel = displayType == .normal ? defaultRecords[indexPath.row] : groupedRecords[indexPath.row]
        cell.textLabel?.attributedText = viewModel.attributedString
        cell.textLabel?.numberOfLines = 0
    }

    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint, displayType: RecordsDisplayType) -> UIContextMenuConfiguration? {
        guard displayType == .normal else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            guard let self = self else { return nil }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.deleteRecord(tableView, at: indexPath)
            }
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
                self.editRecord(at: indexPath)
            }
            return UIMenu(title: "", children: [edit, delete])
        }
    }

    private func updateData() {
        let grouped = Dictionary(grouping: records, by: { $0.addressString }).values
        defaultRecords = records.sorted(by: { $0.createdAt > $1.createdAt }).map(RecordCellViewModel.init)
        groupedRecords = grouped.map(RecordCellViewModel.init)
        tableViewReloadSubject.send()
    }

    public func deleteRecord(_ tableView: UITableView, at indexPath: IndexPath) {
        guard let recordToDelete = self.defaultRecords[indexPath.row].records.first else { return }
        self.recordsDataStore.deleteRecord(record: recordToDelete) { result in
            switch result {
            case .success:
                self.defaultRecords.remove(at: indexPath.row)
                self.records.removeAll(where: { $0 == recordToDelete })
                self.firebaseDataStore?.delete(record: recordToDelete)
            case let .failure(error): print(error) }
        }
    }

    public func editRecord(at indexPath: IndexPath) {
        guard let recordToEdit = self.defaultRecords[indexPath.row].records.first else { return }
        viewSubject.send(.editRecord(record: recordToEdit))
    }

    public func addRecord(_ record: GasRefill) {
        self.firebaseDataStore?.upload(record: record)
        self.records.append(record)
    }

    public func updateRecord(_ record: GasRefill, oldRecord: GasRefill) {
        self.firebaseDataStore?.upload(record: record)
        self.records.removeAll(where: { $0 == oldRecord })
        self.records.append(record)
    }
}
