//
//  RecordCellViewModel.swift
//  TrackEnsureKit
//
//  Created by Yevhenii on 04.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import UIKit

class RecordCellViewModel {

    // MARK: - Properties
    let attributedString: NSMutableAttributedString
    let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    let subtitleFont = UIFont.preferredFont(forTextStyle: .caption1)

    let records: [GasRefill]

    // MARK: - Methods
    init(records: [GasRefill]) {
        self.records = records

        let addressString = records.first?.addressString ?? ""
        let amount = records.map({ $0.amount }).reduce(0, +)
        let price = records.map({ $0.price }).reduce(0, +)
        let title = NSAttributedString(string: addressString + "\n", attributes: [NSAttributedString.Key.font: titleFont])
        let total = NSAttributedString(string: "Total:\n", attributes: [NSAttributedString.Key.font: titleFont])
        let subtitle = NSAttributedString(string: "Volume: \(amount) L ᐧ Money: " + "\(price) UAH ᐧ Records: \(records.count)", attributes: [NSAttributedString.Key.font: subtitleFont])
        self.attributedString = NSMutableAttributedString()
        self.attributedString.append(title)
        self.attributedString.append(total)
        self.attributedString.append(subtitle)
    }

    init(record: GasRefill) {
        self.records = [record]

        let title = NSAttributedString(string: record.addressString + "\n", attributes: [NSAttributedString.Key.font: titleFont])
        let subtitle = NSAttributedString(string: "Provider: " + record.gas.provider + " ᐧ Volume: \(record.amount) L ᐧ Money: " + "\(record.price) UAH", attributes: [NSAttributedString.Key.font: subtitleFont])
        attributedString = NSMutableAttributedString()
        attributedString.append(title)
        attributedString.append(subtitle)
    }
}
