//
//  TweetedPhotos.swift
//  PHImageManagerTwitterDemo
//
//  Created by Simon Gladman on 02/01/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import Foundation
import CoreData

class TweetedPhotos: NSManagedObject
{

    @NSManaged var localIdentifier: String
    @NSManaged var userAction: String

    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, localIdentifier: String, userAction: String) -> TweetedPhotos
    {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("TweetedPhotos", inManagedObjectContext: moc) as TweetedPhotos
        
        newItem.localIdentifier = localIdentifier
        newItem.userAction = userAction
        
        return newItem
    }
}
