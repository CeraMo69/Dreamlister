//
//  MaterialView.swift
//  DreamLister
//
//  Created by Pieter Velghe on 31/10/16.
//  Copyright © 2016 Pieter Velghe. All rights reserved.
//

import UIKit

private var _materialKey = false

extension UIView {

    @IBInspectable var materialDesign: Bool {
        
        get {
            return _materialKey
        }
        set {
            _materialKey = newValue
            
            if _materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0, height: 2)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil

            }
        }
    }

}
