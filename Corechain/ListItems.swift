//
//  ListItems.swift
//  Corechain
//
//  Created by Alex Lopez on 15/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//

import UIKit
import CoreData

class ListItems: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var selected: UISegmentedControl!
    @IBOutlet weak var collectionItems: UICollectionView!
    
    
    var category: Categories?
    var managedContext: NSManagedObjectContext!
    var arrayCurrencies: [Currency] = []
    var optionSelected: String = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = (appDelegate?.persistentContainer.viewContext)!
        collectionItems.delegate = self
        collectionItems.dataSource = self
        categoryTitle.text = category?.name
        selectAllCurrenciesFromCategory()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Selector(_ sender: Any) {
        switch selected.selectedSegmentIndex {
        case 0:
            optionSelected = "none"
            break;
        case 1:
            optionSelected = "Edit"
            break
        case 2:
            optionSelected = "Delete"
            break
        default:
            optionSelected = "none"
            break
        }
        collectionItems.reloadData()
    }
    
    //CollectionView functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (category?.canBe?.count)!
    }
    
    //Item data
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionItems.dequeueReusableCell(withReuseIdentifier: "Item", for: indexPath) as! Item
        cell.currencyImage.image = UIImage(data: arrayCurrencies[indexPath.row].image as! Data)
        cell.currencyName.text = arrayCurrencies[indexPath.row].name
        
        if optionSelected == "none" {
            cell.currencyOption.isHidden = true
        } else {
            cell.currencyOption.isHidden = false
            if optionSelected == "Edit" {
                cell.currencyOption.image = #imageLiteral(resourceName: "edit")
            } else if optionSelected == "Delete" {
                cell.currencyOption.image = #imageLiteral(resourceName: "trash")
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {//Asociamos la vista de editar para cuando pulse entre a dicha vista
        if(segue.identifier == "editItem"){
            let pantalla: EditItem = segue.destination as! EditItem
            let fila = sender as! Int
            pantalla.item = arrayCurrencies[fila]
        }
    }
    
    //Selected Item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if optionSelected == "Edit" {
            self.performSegue(withIdentifier: "editItem", sender: indexPath.row)
        } else if optionSelected == "Delete" {
            managedContext.delete(arrayCurrencies[indexPath.row])
            do{
                try managedContext.save()
                print("currency deleted")
            }catch let error as NSError {
                print(error)
            }
        } else {
            let viewControllerDetails:UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Send info to main storyboard
            let dataItem = viewControllerDetails.instantiateViewController(withIdentifier: "dataItem") as! DataItem
            dataItem.nameCurrency = arrayCurrencies[indexPath.row].name!
            dataItem.img = UIImage(data: arrayCurrencies[indexPath.row].image as! Data)
            dataItem.dateCurrency = arrayCurrencies[indexPath.row].releaseDate!
            dataItem.priceCurrency = Int (arrayCurrencies[indexPath.row].price)
            self.navigationController?.pushViewController(dataItem, animated: true)
        }
        collectionItems.reloadData()
    }
    
    //Extra functions
    func selectAllCurrenciesFromCategory() {
        let fetch = NSFetchRequest<Categories>(entityName: "Categories")
        fetch.predicate = NSPredicate(format: "name == %@", (category?.name)!)
        do {
            let result = try managedContext.fetch(fetch)
            if result.count > 0 {
                let currency = result.first!
                if let currencies = currency.canBe {
                    for c in currencies {
                        arrayCurrencies.append(c as! Currency)
                        print("Modelo: \(c)")
                    }
                }
            } else {
                print("No currencies")
            }
        } catch let error as NSError {
            print(error)
        }
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
