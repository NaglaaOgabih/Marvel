//
//  Series+CoreDataProperties.swift
//  
//
//  Created by Naglaa Ogabih on 17/09/2022.
//
//

import Foundation
import CoreData


extension Series {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Series> {
        return NSFetchRequest<Series>(entityName: "Series")
    }

    @NSManaged public var name: String?
    @NSManaged public var resourceURI: String?
    @NSManaged public var characters: Characters?

}
