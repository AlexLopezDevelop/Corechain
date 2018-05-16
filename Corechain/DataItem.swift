//
//  DataItem.swift
//  Corechain
//
//  Created by Alex Lopez on 7/4/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit

class DataItem: UIViewController {
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var img: UIImage?
    var nameCurrency: String = ""
    var dateCurrency: String = ""
    var priceCurrency: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgCurrency.image = img
        name.text = nameCurrency
        date.text = dateCurrency
        price.text = String (priceCurrency)
        // Do any additional setup after loading the view.
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
