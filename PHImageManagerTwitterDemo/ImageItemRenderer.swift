//
//  ImageItemRenderer.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 31/12/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import Photos

class ImageItemRenderer: UICollectionViewCell
{
    let label = UILabel(frame: CGRectZero)
    let imageView = UIImageView(frame: CGRectZero)
    let blurOverlay = UIVisualEffectView(effect: UIBlurEffect())
    
    let manager = PHImageManager.defaultManager()
    let deliveryOptions = PHImageRequestOptionsDeliveryMode.Opportunistic
    let requestOptions = PHImageRequestOptions()
    
    let thumbnailSize = CGSize(width: 100, height: 100)
   
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        requestOptions.deliveryMode = deliveryOptions
        
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        
        imageView.frame = bounds.rectByInsetting(dx: 0, dy: 0)
        
        let labelFrame = CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20)
        
        blurOverlay.frame = labelFrame
        
        label = UILabel(frame: CGRectZero)
        label.numberOfLines = 0
        label.frame = labelFrame
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.Center
        
        contentView.addSubview(imageView)
        contentView.addSubview(blurOverlay)
        contentView.addSubview(label)
    }
    
    var asset: PHAsset?
    {
        didSet
        {
            if let _asset = asset
            {
                label.text = NSDateFormatter.localizedStringFromDate(_asset.creationDate, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
  
                manager.requestImageForAsset(_asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: requestResultHandler)
            }
        }
    }
    
    func requestResultHandler (image: UIImage!, properties: [NSObject: AnyObject]!) -> Void
    {
        imageView.image = image
    }
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
