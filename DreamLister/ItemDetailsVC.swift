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
    
    var pickerRows = [Store]()
    var itemToEdit: Item?
    var imagePicker = UIImagePickerController()
    var newImage = false
    var storesCount: Int!
    
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
        let count = fetchStoreCount()
        if count == 0 {
            createStores()
        }
        
        fetchStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRows.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRows[row].name
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
    
    func fetchStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            try pickerRows = context.fetch(fetchRequest)
            pickerView.reloadAllComponents()
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

        item.toStore = pickerRows[pickerView.selectedRow(inComponent: 0)]
        
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
                for (index, eachStore) in pickerRows.enumerated() {
                    if eachStore.name == store.name {
                        pickerView.selectRow(index, inComponent: 0, animated: false)
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
