//
//  AddUser.swift
//  Corechain
//
//  Created by Alex Lopez on 9/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit
import CoreData

class AddUser: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addUser(_ sender: Any) {
        passwordMatch()
    }
    
    func insertUser(){
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context!)
        let user = User(entity: userEntity!, insertInto: context)
        user.name = username.text!
        user.password = password.text!
        user.image = UIImagePNGRepresentation(UIImage(named: "defaultImage")!) as NSData? 
        do{
            try context?.save()
        }catch let error as NSError{
            print("Error to save: \(error)")
        }
    }
    
    func passwordMatch(){
        if(password.text != confirmPassword.text){
            createMessage(title: "Error registration", message: "Passwords not match", call: "password")
        }else{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            context = (appDelegate?.persistentContainer.viewContext)!
            insertUser()
            createMessage(title: "Successful Registration", message: "\(username.text!) is registered correctly", call: "success")
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
        confirmPassword.resignFirstResponder()
        return(true)
    }
    
    //Message success
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
