//
//  RecordsViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import Combine

public class RecordsViewModel {

    // MARK: - Properties
    // View Model
    let recordsDataStore: RecordsDataStore

    public let tableViewReloadSubject = PassthroughSubject<Void, Never>()



    var records: [GasRefill] = [] {
        didSet { tableViewReloadSubject.send(()) }
    }

    // MARK: - Methods
    public init(recordsDataStore: RecordsDataStore) {
        self.recordsDataStore = recordsDataStore
    }

    public func loadRecords() {
        switch recordsDataStore.getAllRecords() {
        case let .success(records): self.records = records
        case let .failure(error): print(error) }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    public func tableView(setupCell cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let record = records[indexPath.row]
        let title = NSAttributedString(string: record.addressString + "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        let subtitle = NSAttributedString(string: record.gas.provider + " - \(record.amount) L - " + "\(record.price)", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        let attributedString = NSMutableAttributedString()
        attributedString.append(title)
        attributedString.append(subtitle)
        cell.textLabel?.attributedText = attributedString
        cell.textLabel?.numberOfLines = 0
    }
}


class RecordViewModel {

    // MARK: - Properties
    let attributedString: NSMutableAttributedString

    // MARK: - Methods
    init(record: GasRefill) {
        let title = NSAttributedString(string: record.addressString + "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        let subtitle = NSAttributedString(string: record.gas.provider + " - \(record.amount) L - " + "\(record.price)", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        self.attributedString = NSMutableAttributedString()
        self.attributedString.append(title)
        self.attributedString.append(subtitle)
    }
}
