//
//  Categories+CoreDataProperties.swift
//  Corechain
//
//  Created by Alex Lopez on 15/3/18.
//  Copyright © 2018 alex.lopez. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var canBe: NSSet?

}

// MARK: Generated accessors for canBe
extension Categories {

    @objc(addCanBeObject:)
    @NSManaged public func addToCanBe(_ value: Currency)

    @objc(removeCanBeObject:)
    @NSManaged public func removeFromCanBe(_ value: Currency)

    @objc(addCanBe:)
    @NSManaged public func addToCanBe(_ values: NSSet)

    @objc(removeCanBe:)
    @NSManaged public func removeFromCanBe(_ values: NSSet)

}
