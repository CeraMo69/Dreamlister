//
//  ItemCell.swift
//  DreamLister
//
//  Created by Pieter Velghe on 31/10/16.
//  Copyright © 2016 Pieter Velghe. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "€ \(item.price)"
        type.text = item.toItemType?.type
        details.text = item.details
        thumb.image = item.toImage?.image as? UIImage
    }
    
}
