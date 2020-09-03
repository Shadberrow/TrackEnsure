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
        cell.textLabel?.text = records[indexPath.row].uuid.uuidString
    }
}
