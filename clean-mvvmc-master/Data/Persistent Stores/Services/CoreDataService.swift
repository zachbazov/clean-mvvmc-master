//
//  CoreDataService.swift
//  clean-mvvmc-master
//
//  Created by Developer on 18/09/2023.
//

import CoreData
import CodeBureau

final class CoreDataService: CoreDataPersistable {
    
    static var shared = CoreDataService()
    
    
    private init() {
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = createPersistentContainer()
    
    lazy var mainContext: NSManagedObjectContext = createMainContext()
    
    lazy var privateContext: NSManagedObjectContext = createPrivateContext()
}


extension CoreDataService: CoreDataValueTransformable {
    
    func addTransformer<T>(of type: T.Type, for name: NSValueTransformerName) where T: NSObject {
        
        let valueTransformer = ValueTransformer<T>()
        
        ValueTransformer.setValueTransformer(valueTransformer, forName: name)
    }
}


extension CoreDataService {
    
    private func createPersistentContainer() -> NSPersistentContainer {
        setTransformers()
        
        let container = NSPersistentContainer(name: "CoreDataStore")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                assertionFailure("CoreDataService unresolved error \(error), \(error.userInfo)")
            }
        }
        
        logStoreUrl(for: container)
        
        return container
    }
    
    private func createMainContext() -> NSManagedObjectContext {
        
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        context.parent = privateContext
        
        return context
    }
    
    private func createPrivateContext() -> NSManagedObjectContext {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        return context
    }
}


extension CoreDataService {
    
    private func setTransformers() {
        addTransformer(of: UserDTO.self, for: .user)
        addTransformer(of: SectionDTO.self, for: .section)
        addTransformer(of: MediaDTO.self, for: .media)
    }
    
    
    private func logStoreUrl(for container: NSPersistentContainer) {
        
        guard let persistentStore = container.persistentStoreCoordinator.persistentStores.first else { return }
        
        let url = container.persistentStoreCoordinator.url(for: persistentStore)
        
        debugPrint(.url, "CoreDataService Store URL: \(url)")
    }
}

extension CoreDataService {
    
    func context() -> NSManagedObjectContext {
        return mainContext
    }
    
    func saveContext() {
        mainContext.performAndWait { [weak self] in
            guard let self = self else { return }
            
            do {
                guard self.mainContext.hasChanges else { return }
                
                try self.mainContext.save()
            } catch {
                assertionFailure("CoreDataService main context unresolved error \(error), \((error as NSError).userInfo)")
            }
            
            self.privateContext.perform {
                do {
                    guard self.privateContext.hasChanges else { return }
                    
                    try self.privateContext.save()
                } catch {
                    assertionFailure("CoreDataService private context unresolved error \(error), \((error as NSError).userInfo)")
                }
            }
        }
    }
}
