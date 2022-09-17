//
//  Characters+CoreDataProperties.swift
//  
//
//  Created by Naglaa Ogabih on 17/09/2022.
//
//

import Foundation
import CoreData


extension Characters {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Characters> {
        return NSFetchRequest<Characters>(entityName: "Characters")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var resultDescription: String?
    @NSManaged public var thumbnailExtension: String?
    @NSManaged public var series: NSSet?

}

// MARK: Generated accessors for series
extension Characters {

    @objc(addSeriesObject:)
    @NSManaged public func addToSeries(_ value: Series)

    @objc(removeSeriesObject:)
    @NSManaged public func removeFromSeries(_ value: Series)

    @objc(addSeries:)
    @NSManaged public func addToSeries(_ values: NSSet)

    @objc(removeSeries:)
    @NSManaged public func removeFromSeries(_ values: NSSet)

}
