//
//  ViewController.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 31/12/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let tweetabePhotosBrowser = TweetablePhotosBrowser(frame: CGRectZero)
    let tweetedPhotosBrowser = TweetedPhotosBrowser(frame: CGRectZero)
    
    let coreDataDelegate = CoreDataDelegate()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tweetabePhotosBrowser.coreDataDelegate = coreDataDelegate
        tweetedPhotosBrowser.coreDataDelegate = coreDataDelegate
        
        tweetabePhotosBrowser.addTarget(self, action: "tweetabePhotosBrowserChange", forControlEvents: UIControlEvents.ValueChanged)
        
        view.addSubview(tweetabePhotosBrowser)
        view.addSubview(tweetedPhotosBrowser)
    }
    
    func tweetabePhotosBrowserChange()
    {
        tweetedPhotosBrowser.refresh()
    }
    
    override func viewDidLayoutSubviews()
    {
        tweetabePhotosBrowser.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2.0).rectByInsetting(dx: 10, dy: 20)
        
        tweetedPhotosBrowser.frame = CGRect(x: 0, y: view.frame.height / 2.0, width: view.frame.width, height: view.frame.height / 2.0).rectByInsetting(dx: 10, dy: 20)
    }

}

