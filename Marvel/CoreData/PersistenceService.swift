//
//  PersistenceService.swift
//  Marvel
//
//  Created by Naglaa Ogabih on 17/09/2022.
//

import Foundation
import CoreData

class PersistenceService{
        private init() {}
    static var context : NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CharactersModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func series(name: String, resourceUrl : String, character:  Characters) -> Series{
        let series = Series(context: PersistenceService.persistentContainer.viewContext)
        series.name = name
        series.resourceURI = resourceUrl
        series.characters = character
        return series
    }
    // MARK: - Core Data Saving support
   static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
