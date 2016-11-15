//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Pieter Velghe on 28/10/16.
//  Copyright © 2016 Pieter Velghe. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
