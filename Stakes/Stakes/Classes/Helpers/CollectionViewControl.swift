//
//  CollectionViewControl.swift
//  Created by Dmitry Nezhidenko on 1/5/18.
//

import UIKit


// MARK: - Protocol for cell
@objc protocol CollectionViewCellProtocol {
    
    // Required
    var parentVC: UIViewController? { get set }
    func configure(withModel model: AnyObject) -> UICollectionViewCell
    
    // Optional
    @objc optional func didSelectActionInCell()
}

// MARK: - Base extension
extension UICollectionViewCell {
    
    public static var reuseID: String {
        return String(describing: self)
    }
}


// MARK: - CollectionViewControl
class CollectionViewControl: NSObject {
    typealias DidSelectCellBlock = () -> ()
    
    
    // MARK: Required
    var cellID: String
    var cellSize: CGSize
    var dataSource = [AnyObject]()
    
    
    // MARK: Optional
    var minimumLineSpacing: CGFloat?
    var minimumInteritemSpacing: CGFloat?
    var didSelectActionInVC: DidSelectCellBlock?
    weak var parentVC: UIViewController?
    
    
    // MARK: Initializers
    init(collectionView: UICollectionView, cellID: String, and cellSize: CGSize) {
        self.cellID = cellID
        self.cellSize = cellSize
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


// MARK: - Collection View Data Source

extension CollectionViewControl: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        collectionView.isHidden = dataSource.count == 0
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionViewCellProtocol
        cell.parentVC = parentVC
        return cell.configure(withModel: dataSource[indexPath.row])
    }
}


// MARK: - Collection View Delegate

extension CollectionViewControl: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let didSelectCell = didSelectActionInVC {
            didSelectCell()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCellProtocol
            cell.didSelectActionInCell!()
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewControl: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumInteritemSpacing ?? 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minimumLineSpacing ?? 1.0
    }
}
