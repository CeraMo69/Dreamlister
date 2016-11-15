//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Pieter Velghe on 28/10/16.
//  Copyright © 2016 Pieter Velghe. All rights reserved.
//

import Foundation
import CoreData

extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
