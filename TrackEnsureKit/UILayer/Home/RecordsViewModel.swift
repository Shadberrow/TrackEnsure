//
//  RecordsViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine

public enum RecordsDisplayType {
    case normal
    case grouped
}

public class RecordsViewModel {

    // MARK: - Properties
    // View Model
    let recordsDataStore: RecordsDataStore
    let displayType: RecordsDisplayType

    public let tableViewReloadSubject = PassthroughSubject<Void, Never>()

    var defaultRecords: [RecordCellViewModel] = []
    var groupedRecords: [RecordCellViewModel] = []

    var records: [GasRefill] = [] {
        didSet { updateData() }
    }

    // MARK: - Methods
    public init(recordsDataStore: RecordsDataStore,
                displayType: RecordsDisplayType) {
        self.recordsDataStore = recordsDataStore
        self.displayType = displayType
    }

    public func loadRecords() {
        switch recordsDataStore.getAllRecords() {
        case let .success(records): self.records = records
        case let .failure(error): print(error) }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch displayType {
        case .normal: return defaultRecords.count
        case .grouped: return groupedRecords.count }
    }

    public func tableView(setupCell cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModel = displayType == .normal ? defaultRecords[indexPath.row] : groupedRecords[indexPath.row]
        cell.textLabel?.attributedText = viewModel.attributedString
        cell.textLabel?.numberOfLines = 0
    }

    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard displayType == .normal else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] suggestedActions in
            guard let self = self else { return nil }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                guard let recordToDelete = self.defaultRecords[indexPath.row].records.first else { return }
                switch self.recordsDataStore.deleteRecord(record: recordToDelete) {
                case .success:
                    self.defaultRecords.remove(at: indexPath.row)
                    self.records.removeAll(where: { $0 == recordToDelete })
                    self.tableViewReloadSubject.send(())
                case let .failure(error): print(error) }
            }

            return UIMenu(title: "", children: [delete])
        }
    }

    private func updateData() {
        switch displayType {
        case .normal:
            defaultRecords = records.sorted(by: { $0.createdAt > $1.createdAt })
                .map(RecordCellViewModel.init)
        case .grouped:
            groupedRecords = Dictionary(grouping: records, by: { $0.addressString }).values
                .sorted(by: { $0.map({ $0.price }).reduce(0, +) > $1.map({ $0.price }).reduce(0, +) })
                .map(RecordCellViewModel.init)
        }
        tableViewReloadSubject.send(())
    }

    private func deleteRecord(_ record: GasRefill) {
//        switch recordsDataStore.deleteRecord(record: record) {
//        case .success:
//            guard let recordToDelete = defaultRecords[indexPath.row].records.first else { return }
//            records.remove(at: indexPath.row)
//            updateData()
//        case let .failure(error):
//            print(error) }
    }
}
