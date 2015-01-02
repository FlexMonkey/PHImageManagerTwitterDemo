//
//  TweetablePhotosBrowser.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 02/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit
import Photos

class TweetedPhotosBrowser: UIControl, UICollectionViewDataSource, UICollectionViewDelegate
{
    let label = UILabel(frame: CGRectZero)
    let manager = PHImageManager.defaultManager()
    var images = [TweetedPhotos]()
    
    var collectionViewWidget: UICollectionView!
  
    var coreDataDelegate: CoreDataDelegate?
    {
        didSet
        {
            refresh()
        }
    }
    
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
        
        label.text = "Tweeted Photos"
        
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
    
    func refresh()
    {
        if let _coreDataDelegate = coreDataDelegate
        {
            images = _coreDataDelegate.getTweetablePhotos()
            
            if collectionViewWidget != nil
            {
                collectionViewWidget.reloadData()
            }
        }
    }

    // collection view delegate functions

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ImageItemRenderer
        
        let tweetedPhoto = images[indexPath.row] as TweetedPhotos

        let assets = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        
        for i in 0 ..< assets.count
        {
            if assets[i].localIdentifier == tweetedPhoto.localIdentifier
            {
                cell.asset = assets[i] as PHAsset!
                break
            }
        }
  
        return cell
    }
    
}
