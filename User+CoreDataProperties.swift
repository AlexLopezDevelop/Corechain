//
//  User+CoreDataProperties.swift
//  Corechain
//
//  Created by Alex Lopez on 15/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var password: String?

}
