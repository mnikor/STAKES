//
//  TableControlModels.swift
//  KADER
//
//  Created by Alen Korbut on 30.03.17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//
//  All this classes can be stored here while we don't have too much info inside each model class

import Foundation
import UIKit

final class TableRowModel: NSObject {
    typealias ConfigCellAction = (UITableViewCell, TableRowModel, TableSectionModel)->()
    
    let cellIdentifier: String
    let configCellAction: ConfigCellAction
    
    init(cellIdentifier: String, configCellAction: @escaping ConfigCellAction) {
        self.cellIdentifier = cellIdentifier
        self.configCellAction = configCellAction
        super.init()
    }
}
final class TableSectionModel: NSObject {
    var rows: [TableRowModel] = []
}
final class TableModel: NSObject {
    var sections: [TableSectionModel] = []
}
