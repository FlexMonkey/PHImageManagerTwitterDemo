//
//  CoreDataDelegate.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 02/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataDelegate
{
    let appDelegate: AppDelegate
    let managedObjectContext: NSManagedObjectContext
    
    init()
    {
        appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = appDelegate.managedObjectContext!
    }
    
    
    func saveTweetablePhoto(#localIdentifier: String, userAction: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedObjectContext = appDelegate.managedObjectContext!
        
        var newEntity = TweetedPhotos.createInManagedObjectContext(managedObjectContext, localIdentifier: localIdentifier, userAction: userAction)

        appDelegate.saveContext()
        
        println("context saved  \(newEntity.userAction) \(localIdentifier)")
    }
    
    func getTweetablePhotos() -> [TweetedPhotos]
    {
        let fetchRequest = NSFetchRequest(entityName: "TweetedPhotos")
        
        if let fetchResults = managedObjectContext.executeFetchRequest(fetchRequest, error: nil) as? [TweetedPhotos]
        {
            return fetchResults
        }
        else
        {
            return [TweetedPhotos]()
        }
    }
    
}