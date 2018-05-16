//
//  editProfile.swift
//  Corechain
//
//  Created by Alex Lopez on 10/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit
import CoreData

class editProfile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userLogged != nil {
            profileImage.image = UIImage(data: userLogged?.image as! Data)
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = (appDelegate?.persistentContainer.viewContext)!
        self.username.delegate = self
        self.password.delegate = self
        self.confirmPassword.delegate = self
    }
    
    //Modify data from user
    @IBAction func modifyProfile(_ sender: Any) {
        modifyUser()
    }
    
    
    //Log out session
    @IBAction func logout(_ sender: Any) {
        createMessage(title: "Log out", message: "Are you sure to log out?")
    }
    
    //Access gallery
    @IBAction func gallery(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
        }
    }
    
    //Access camera
    @IBAction func camera(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = false
        
        self.present(image, animated: true){
        }
    }
    
    //FUNCTIONS ------------------------------------------------------------>
    //Edit profile
    func modifyUser() {
        ProgressHUD.show("Watting...", interaction: false)
        userLogged?.name = username.text!
        userLogged?.password = password.text!
        userLogged?.image = UIImagePNGRepresentation(profileImage.image!) as NSData?
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context!)
        let user = User(entity: userEntity!, insertInto: context!)
        
        do {
            ProgressHUD.showSuccess("Success")
            try context?.save()
            
        } catch let error as NSError {
            ProgressHUD.showError("Error to modify profile")
            print(error)
        }
    }
    
    //Add image to imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info [UIImagePickerControllerOriginalImage] as? UIImage{
            profileImage.image = image
        }else{
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Message log out
    func createMessage (title:String, message:String){
        let message = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        message.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (action) in
            message.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "logout", sender: self)
        }))
        
        message.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (action) in
            message.dismiss(animated: true, completion: nil)
            
        }))
        self.present(message, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
