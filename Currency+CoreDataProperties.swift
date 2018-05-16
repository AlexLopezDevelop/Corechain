//
//  Currency+CoreDataProperties.swift
//  Corechain
//
//  Created by Alex Lopez on 15/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//
//

import Foundation
import CoreData


extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var releaseDate: String?
    @NSManaged public var type: Categories?

}
