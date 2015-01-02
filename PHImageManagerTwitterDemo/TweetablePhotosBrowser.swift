//
//  TweetablePhotosBrowser.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 02/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit
import Photos
import Social

class TweetablePhotosBrowser: UIControl, UICollectionViewDataSource, UICollectionViewDelegate
{
    let label = UILabel(frame: CGRectZero)
    let manager = PHImageManager.defaultManager()
    let assets = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
    
    var selectedAsset: PHAsset?
    
    var collectionViewWidget: UICollectionView!
    var coreDataDelegate: CoreDataDelegate?
    
    override func didMoveToSuperview()
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionViewWidget = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        collectionViewWidget.backgroundColor = UIColor.clearColor()
        
        collectionViewWidget.delegate = self
        collectionViewWidget.dataSource = self
        collectionViewWidget.registerClass(ImageItemRenderer.self, forCellWithReuseIdentifier: "Cell")
        collectionViewWidget.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        label.text = "Tweetable Photos"
        
        addSubview(collectionViewWidget)
        addSubview(label)
        
        layer.borderColor = UIColor.blueColor().CGColor
        layer.borderWidth = 2
        
        layer.masksToBounds = true
    }
    
    
    override func layoutSubviews()
    {
        collectionViewWidget.frame = CGRect(x: 0, y: 30, width: frame.width, height: frame.height)
        
        label.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30).rectByInsetting(dx: 10, dy: 0)
    }
    
    func requestResultHandler (image: UIImage!, properties: [NSObject: AnyObject]!) -> Void
    {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter)
        {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterController.setInitialText("Here's a photo from my album!")
            twitterController.addURL(NSURL(string: "http://flexmonkey.blogspot.co.uk"))
            twitterController.addImage(image)
            
            twitterController.completionHandler = twitterControllerCompletionHandler
            
            if let viewController = window?.rootViewController as? ViewController
            {
                viewController.presentViewController(twitterController, animated: true, completion: nil)
            }
        }
        else
        {
            var alertController = UIAlertController(title: "Twitter Unavailable", message: "Sorry, Twitter is unavailable.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            
            if let viewController = window?.rootViewController as? ViewController
            {
                viewController.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func twitterControllerCompletionHandler(result: SLComposeViewControllerResult) -> Void
    {
        if let _coreDataDelegate = coreDataDelegate
        {
            let userAction = result.rawValue == 0 ? "Cancelled" : "Tweeted"
            _coreDataDelegate.saveTweetablePhoto(localIdentifier: selectedAsset!.localIdentifier, userAction: userAction)
            
            sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    // collection view delegate functions
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        selectedAsset = assets[indexPath.row] as? PHAsset
        
        let targetSize = CGSize(width: selectedAsset!.pixelWidth, height: selectedAsset!.pixelHeight)
        let deliveryOptions = PHImageRequestOptionsDeliveryMode.HighQualityFormat
        let requestOptions = PHImageRequestOptions()
        
        requestOptions.deliveryMode = deliveryOptions
        
        manager.requestImageForAsset(selectedAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: requestResultHandler)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return assets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ImageItemRenderer
        
        let asset = assets[indexPath.row] as PHAsset
        
        cell.asset = asset
        
        return cell
    }
    
}
