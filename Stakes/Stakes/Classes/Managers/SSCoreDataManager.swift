//
//  SSCoreDataManager.swift
//  Stakes
//
//  Created by Dmitry Nezhidenko on 11/16/17.
//  Copyright © 2017 Rubiconware. All rights reserved.
//

import CoreData
import Foundation


enum CoredataObjectType: String {
    
    case goal = "Goal"
    case action = "Action"
    case lesson = "Lesson"
    
    static let allValues = [goal, action, lesson]
}


class SSCoreDataManager {
    
    
    //  MARK: Singleton
    static let instance = SSCoreDataManager()
    private init() {}
    
    
    // MARK: Entity for Name
    func entityForName(entityName: CoredataObjectType) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName.rawValue, in: self.managedObjectContext)!
    }
    
    
    // MARK: Fetched Results Controller for Entity Name
    func fetchedResultsController(entityName: CoredataObjectType, keyForSort: String, predicate: [String : String]?) -> NSFetchedResultsController<NSFetchRequestResult> {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let filter = predicate, filter.count == 1 {
            let fetchPredicate = NSPredicate(format: "%K == %@", filter.keys.first!, filter.values.first!)
            fetchRequest.predicate = fetchPredicate
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SSCoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }
    
    
    // MARK: Loading without connect to the internet
    public func loadObjectsFromCoredata(type: CoredataObjectType) -> [AnyObject] {
        
        var objectsArray: [AnyObject] = []
        let managerContext = SSCoreDataManager.instance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type.rawValue)
        
        do {
            let object: [AnyObject] =  try managerContext.fetch(fetchRequest) as [AnyObject]
            objectsArray = object
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return objectsArray
    }
    
    
    // MARK: Deleting objects from the local coredata
    public func deleteAllInstancesFromCoredata() -> Void {
        
        let managerContext = SSCoreDataManager.instance.managedObjectContext
        let store: NSPersistentStore = (managerContext.persistentStoreCoordinator?.persistentStores.last)!
        
        do {
            try managerContext.persistentStoreCoordinator?.remove(store)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try FileManager.default.removeItem(at: store.url!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Core Data stack
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("DB Location - \(urls[urls.count-1])")
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Stakes", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: url,
                                               options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}
