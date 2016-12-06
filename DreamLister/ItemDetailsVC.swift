//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Pieter Velghe on 4/11/16.
//  Copyright © 2016 Pieter Velghe. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()
    var itemtypes = [ItemType]()
    var itemToEdit: Item?
    var imagePicker = UIImagePickerController()
    var newImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil) // topItem is still referring to the previous VC in this viewDidLoad method, could also be placed inside the previous VC under viewDidLoad via self.navigationItem.backBar...
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        imagePicker.delegate = self
        
        /* Manages only executing createStores if the context.count ( count )
         regarding Store(s) is equal to 0. */
        let countStores = fetchStoreCount()
        let countItemTypes = fetchItemTypeCount()
        
        if countStores == 0 {
            createStores()
        }
        if countItemTypes == 0 {
            createItemTypes()
        }
        
        fetchStores()
        fetchItemTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return stores.count
        case 1: return itemtypes.count
        default: return 6
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return stores[row].name
        case 1: return itemtypes[row].type
        default: return "Error \(row)"
        }
    }
    
    func createStores() {
        
        let store1 = Store(context: context)
        store1.name = "Bol.com"
        let store2 = Store(context: context)
        store2.name = "Mediamarkt"
        let store3 = Store(context: context)
        store3.name = "Leterme"
        let store4 = Store(context: context)
        store4.name = "Krefel"
        let store5 = Store(context: context)
        store5.name = "Kobo eBooks"
        let store6 = Store(context: context)
        store6.name = "Colruyt"
        
        ad.saveContext()
    }
    
    func createItemTypes() {
        
        let itemType1 = ItemType(context: context)
        itemType1.type = "Car"
        let itemType2 = ItemType(context: context)
        itemType2.type = "Electronics"
        let itemType3 = ItemType(context: context)
        itemType3.type = "Course"
        let itemType4 = ItemType(context: context)
        itemType4.type = "Devslopes"
        let itemType5 = ItemType(context: context)
        itemType5.type = "Nature"
        let itemType6 = ItemType(context: context)
        itemType6.type = "Goals"
        
        ad.saveContext()
    }
    
    func fetchStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            try stores = context.fetch(fetchRequest)
            pickerView.reloadComponent(0)
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    func fetchItemTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            try itemtypes = context.fetch(fetchRequest)
            pickerView.reloadComponent(1)
        } catch let err as NSError {
            print(err.description)
        }
    }
    
    func fetchStoreCount() -> Int {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            print("Current Store Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
    }
    
    func fetchItemTypeCount() -> Int {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            print("Current Item Type Data Count : \(count)")
            return count
        } catch let err as NSError {
            print(err.description)
            return 0
        }
    }

    @IBAction func savePressed(_ sender: Any) {
        
        let item: Item!
        let picture: Image!
        
        // Added a few things to maintain healthy image data object cycle
        if itemToEdit == nil {
            item = Item(context: context)
            picture = Image(context: context)
        } else {
            item = itemToEdit
            if newImage {
                context.delete(item.toImage!)
                picture = Image(context: context)
            } else {
            picture = itemToEdit?.toImage
            }
        }
        
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        if let details = detailsField.text {
            item.details = details
        }
        
        picture.image = thumbImg.image
        item.toImage = picture

        item.toStore = stores[pickerView.selectedRow(inComponent: 0)]
        item.toItemType = itemtypes[pickerView.selectedRow(inComponent: 1)]
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImg.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                for (index, eachStore) in stores.enumerated() {
                    if eachStore.name == store.name {
                        pickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
                
            }
            if let type = item.toItemType {
                for (index, eachType) in itemtypes.enumerated() {
                    if eachType.type == type.type {
                        pickerView.selectRow(index, inComponent: 1, animated: false)
                        break
                    }
                }
                
            }
        
        }
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            if let containsImage = itemToEdit?.toImage { // Added to maintain healthy image data object cycle
                context.delete(containsImage)
            }
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = image
            newImage = true
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
