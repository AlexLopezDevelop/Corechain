//
//  LogIn.swift
//  Corechain
//
//  Created by Alex Lopez on 10/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit
import CoreData

var categories = [Categories]()
var userLogged: User?

class LogIn: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = (appDelegate?.persistentContainer.viewContext)!
        verificateList()
        self.username.delegate = self
        self.password.delegate = self
    }
    
    @IBAction func logIn(_ sender: Any) {
        ProgressHUD.show("Watting...", interaction: false) //Visual loading ingormation
        verifyUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func verifyUser() {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name == %@ and password == %@", username.text!, password.text!)
        
        var users = [User]()
        
        do {
            try users = (context?.fetch(fetchRequest))!
            if users.count > 0 {
                userLogged = users[0]
                ProgressHUD.showSuccess("Success")
               performSegue(withIdentifier: "logged", sender: self)
            } else {
                ProgressHUD.showError("Username or password wrong")
                //createMessage(title: "Error log In", message: "Username or password wrong", call: "")
            }
        } catch let error as NSError {
            print(error)
        }

    }
    
    func verificateList() {
        if (existCategories().count == 0){
            insertCategories()
        }
        for i in existCategories(){
            categories.append(i)
        }
    }
    
    func insertCategories() {
        let categoriesEntity = NSEntityDescription.entity(forEntityName: "Categories", in: context!)
        
        let Currency = Categories(entity: categoriesEntity!, insertInto: context)
        Currency.name = "Currency"
        let Utility = Categories(entity: categoriesEntity!, insertInto: context)
        Utility.name = "Utility"
        let Platform = Categories(entity: categoriesEntity!, insertInto: context)
        Platform.name = "Platform"
        let Fintech = Categories(entity: categoriesEntity!, insertInto: context)
        Fintech.name = "Fintech"
        let Sovereignty = Categories(entity: categoriesEntity!, insertInto: context)
        Sovereignty.name = "Sovereignty"
        let Authenticity = Categories(entity: categoriesEntity!, insertInto: context)
        Authenticity.name = "Authenticity"
        
        do {
            try context?.save()
        } catch let error as NSError{
            print("Error to save: \(error)")
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
    
    //Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return(true)
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
