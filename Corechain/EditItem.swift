//
//  EditItem.swift
//  Corechain
//
//  Created by Alex Lopez on 9/4/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit
import CoreData

class EditItem: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var type: UIPickerView!
    
    var item: Currency?
    var context: NSManagedObjectContext?
    
    var currencyCategory = Categories()
    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = (appDelegate?.persistentContainer.viewContext)!
        self.name.delegate = self
        self.date.delegate = self
        self.price.delegate = self
        self.type.delegate = self
        categories = existCategories()
        createDatePicker()
    }
    
    //Custom pickerView in alert
    let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    @IBAction func addCurrencyImage(_ sender: Any) {
        let alert = UIAlertController(title: "Currencies", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            
            self.currencyImage.image = self.imageType
 
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    @IBAction func save(_ sender: Any) {
        editCurrency()
    }
    
    func editCurrency() {
        ProgressHUD.show("Watting...", interaction: false)
        item?.name = name.text
        item?.releaseDate = date.text
        item?.price = Int32(price.text!)!
        item?.image = UIImagePNGRepresentation(currencyImage.image!) as NSData?
        item?.type = currencyCategory
        
        let currencyEntity = NSEntityDescription.entity(forEntityName: "Currency", in: context!)
        let curren = Currency(entity: currencyEntity!, insertInto: context!)
        
        do {
            ProgressHUD.showSuccess("Success")
            try context?.save()
            
        } catch let error as NSError {
            ProgressHUD.showError("Error to modify profile")
            print(error)
        }
    }
    
    //Picker Date
    let datePicker = UIDatePicker()
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        date.inputAccessoryView = toolbar
        date.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: datePicker.date)
        
        date.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    var choices = ["Ethereum","Filecoin","Litecoin","Bitcoin Cash","Monero","Dash","Zcash","Augur","0x","DogeCoin"]
    var pickerView = UIPickerView()
    var imageType: UIImage? = nil
    
    //
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerFrame) { //Differentiate pikerViews
            return choices.count
        } else {
            return categories.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerFrame) {
            return choices[row]
        }else {
            return categories[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerFrame) {
            if row == 0 {
                imageType = #imageLiteral(resourceName: "ethereum")
            } else if row == 1 {
                imageType = #imageLiteral(resourceName: "FileCoin")
            } else if row == 2 {
                imageType = #imageLiteral(resourceName: "litecoin")
            } else if row == 3 {
                imageType = #imageLiteral(resourceName: "Bitcoin-Cash")
            } else if row == 4 {
                imageType = #imageLiteral(resourceName: "monero")
            } else if row == 5 {
                imageType = #imageLiteral(resourceName: "dash")
            } else if row == 6 {
                imageType = #imageLiteral(resourceName: "zcash")
            } else if row == 7 {
                imageType = #imageLiteral(resourceName: "augur")
            } else if row == 8 {
                imageType = #imageLiteral(resourceName: "0xCurren")
            } else if row == 9 {
                imageType = #imageLiteral(resourceName: "dogecoin")
            }
        } else {
            print("COSA:\(categories[row])")
            currencyCategory = categories[row]
        }
    }
    
    func existCategories() -> [Categories] {
        let fetchRequest = NSFetchRequest<Categories>(entityName: "Categories")
        print("COSA:\(fetchRequest)")
        do{
            return(try! context?.fetch(fetchRequest))!
        }
    }
    
    //Extra functions (Visual) -------------------------------------------------->
    
    //Message
    func createMessage (title:String, message:String, call:String){
        let message = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            message.dismiss(animated: true, completion: nil)
            if(call.contains("success")){
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(message, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
