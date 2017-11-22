//
//  TableControl.swift
//  KADER
//
//  Created by Anton Klysa on 3/30/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//
//  Table Control works only with Storyboard cell identifiers

import Foundation
import UIKit

final class TableControl: NSObject {
    //MARK: - Delegate -
    
    class Delegate {
        typealias MainBlock = ((TableControl)->())
        typealias SectionBlock = ((TableControl, TableSectionModel)->())
        typealias DidSelectIndexPathBlock = ((NSIndexPath)->())
        
        var tableControlDidHandleRefresh: MainBlock? = nil
        var tableControlWillDisplayLastCell: SectionBlock? = nil
        var tableViewDidSelectRowAt: DidSelectIndexPathBlock? = nil
    }
    var delegate: Delegate? = nil
    var rowHeight: CGFloat?
    var currentOffset = 0
    var currentSection: TableSectionModel?
    var canBeEdited: Bool?
    
    static let kCountElements: Int = 25
    
    
    //MARK: - Props -
    
    private weak var tableView: UITableView!
    private weak var refreshControl: UIRefreshControl!
    
    fileprivate(set) var tableModel = TableModel()
    
    fileprivate var _didStopScrolling: (()->())? = nil
    fileprivate var _appendDataWhileScrolling = false
    
    //MARK: - Init -
    
    init(tableView: UITableView, rowHeight: CGFloat, canBeEdited: Bool) {
        super.init()
        
        //base config
        self.canBeEdited = canBeEdited
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .gray
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.backgroundView = refreshControl
        self.refreshControl = refreshControl
        
        if rowHeight != 0 {
            self.rowHeight = rowHeight
        } else {
            self.tableView.delegate = nil
            self.tableView.estimatedRowHeight = 70
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    //MARK: - Actions -
    
    @objc func handleRefresh() {
        delegate?.tableControlDidHandleRefresh?(self)
    }
    
    
    //MARK: - Main -
    
    func endRefreshing() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    func reloadData(tableModel: TableModel) {
        //simply set new table model
        self.tableModel = tableModel
        reloadTableView()
    }
    func reloadData(sections: [TableSectionModel]) {
        //simply set new sections
        tableModel.sections = sections
        reloadTableView()
    }
    func reloadData(rows: [TableRowModel]) {
        tableModel.sections.removeAll()
        
        //create default section & add rows
        let section = TableSectionModel()
        section.rows = rows
        tableModel.sections.append(section)
        
        reloadTableView()
    }
    func appendRows(rows: [TableRowModel], to section: TableSectionModel) {
        //already adding something...
        if _appendDataWhileScrolling {
            return
        }
        
        //get indexes
        guard let sectionIdx = tableModel.sections.index(where: { $0 == section }) else { return }
        let originIdx = section.rows.count
        
        //add paths for new rows
        var paths: [IndexPath] = []
        for tmp in 0..<rows.count {
            let path = IndexPath(row: originIdx+tmp, section: sectionIdx)
            paths.append(path)
        }
        
        //update after anim stop
        if tableView.isDecelerating || tableView.isDragging {
            _appendDataWhileScrolling = true
            _didStopScrolling = { [weak self, weak section] in
                self?._appendDataWhileScrolling = false
                section?.rows.append(contentsOf: rows)
                self?.tableView.insertRows(at: paths, with: .automatic)
            }
        }
        else { //update immediately
            section.rows.append(contentsOf: rows)
            tableView.insertRows(at: paths, with: .automatic)
        }
    }
    
    func reloadTableView() {
        _appendDataWhileScrolling = false
        tableView.reloadData()
        endRefreshing()
    }
    
    //MARK: - Private -
}

//MARK: - Table DataSource -

extension TableControl: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableModel.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)
        row.configCellAction(cell, row, section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            currentSection?.rows.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.canBeEdited!
    }
}

//MARK: - Table Delegate -

extension TableControl: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            _didStopScrolling?()
            _didStopScrolling = nil
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _didStopScrolling?()
        _didStopScrolling = nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if _appendDataWhileScrolling {
            return
        }
        let section = tableModel.sections[indexPath.section]
        currentSection = section
        if indexPath.row == section.rows.count - 1 {
            delegate?.tableControlWillDisplayLastCell?(self, section)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableViewDidSelectRowAt?(indexPath as NSIndexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight!
    }
}
