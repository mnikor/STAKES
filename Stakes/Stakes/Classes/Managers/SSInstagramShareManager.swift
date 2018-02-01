//
//  SSInstagramShareManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 1/11/18.
//  Copyright © 2018 Rubiconware. All rights reserved.
//

import UIKit
import Photos

class SSInstagramShareManager: NSObject {
    
    func post(image: UIImage, result:@escaping ((Bool)->Void)) {
        
        var shareURL = "instagram://library?OpenInEditor=1&LocalIdentifier="
        
        PHPhotoLibrary.shared().performChanges({

            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
            shareURL += assetID
            
        }) { (bool, error) in
            guard bool else { return }
            
            if let urlForRedirect = URL(string: shareURL) {
                
                UIApplication.shared.openURL(urlForRedirect)
                result(true)
            } else {
                result(false)
            }
        }
    }
    
    
    func post(image: UIImage, dic: UIDocumentInteractionController, vc: UIViewController) {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let saveImagePath = (documentsPath as NSString).appendingPathComponent("Image.igo")
        let imageData = UIImagePNGRepresentation(image)
        let imageDataNS = NSData(data: imageData!)

        do {
            try imageDataNS.write(toFile: saveImagePath, options: NSData.WritingOptions(rawValue: 0))
        } catch {
            SSMessageManager.showAlertWith(error: error, onViewController: vc)
        }

        let imageURL = URL(fileURLWithPath: saveImagePath)
        dic.url = imageURL
        dic.uti = "com.instagram.exclusivegram"

        if dic.presentOpenInMenu(from: CGRect(), in: vc.view, animated: true) {
            
        } else {
            SSMessageManager.showAlertWith(title: .failure, and: .error, onViewController: vc)
        }
    }
}
