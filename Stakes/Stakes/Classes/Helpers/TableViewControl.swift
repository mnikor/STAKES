//
//  MATableViewControlSimple.swift
//
//  Created by Dmitry Nezhidenko on 1/8/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit


@objc protocol TableViewCellProtocol {
    
    // Required
    var parentVC: UIViewController? { get set }
    func configure(withModel model: AnyObject, forSection: Int) -> UITableViewCell
    
    // Optional
    @objc optional func didSelectActionInCell(_ indexPath: IndexPath)
}


struct Section {
    let name: String?
    var dataSource: [AnyObject]
    let sectionView: UIView?
    
    init(dataSource: [AnyObject], sectionView: UIView? = nil, name: String? = nil) {
        self.name = name
        self.dataSource = dataSource
        self.sectionView = sectionView
    }
}


class TableViewControl: NSObject {
    typealias DidSelectCellBlock = (_ indexPath: IndexPath) -> ()
    typealias DidScroll = (_ scrollView: UIScrollView) -> ()
    
    
    // MARK: Required
    var cellID: String
    var sections = [Section]()
    
    
    // MARK: Optional
    var cellHeight: CGFloat?
    var didScroll: DidScroll?
    var didSelectActionInVC: DidSelectCellBlock?
    weak var parentVC: UIViewController?
    
    
    // MARK: Initializers
    init(tableView: UITableView, cellID: String) {
        self.cellID = cellID
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
    }
}


// MARK: - Table view data source

extension TableViewControl: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        tableView.isHidden = sections.count == 0
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let sectionView = sections[section].sectionView {
            return sectionView.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TableViewCellProtocol
        let model = sections[indexPath.section].dataSource[indexPath.row]
        
        cell.parentVC = parentVC
        return cell.configure(withModel: model, forSection: indexPath.section)
    }
}


// MARK: - Table View Delegate

extension TableViewControl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let didSelectCell = didSelectActionInVC {
            didSelectCell(indexPath)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCellProtocol
            cell.didSelectActionInCell!(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight == nil ? UITableViewAutomaticDimension : cellHeight!
    }
    
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let scroll = didScroll {
            scroll(scrollView)
        }
    }
}
