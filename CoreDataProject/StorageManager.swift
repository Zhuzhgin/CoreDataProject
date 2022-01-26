//
//  StorageManager.swift
//  CoreDataProject
//
//  Created by Artem Zhuzhgin on 26.01.2022.
//

import Foundation
import CoreData

class StorageManager {
    static var shared = StorageManager()
    private init() {}

   var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "CoreDataProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
           
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

      func saveContext (taskName: String, complition: @escaping(_ task: Task) -> Void) {
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.name = taskName
        complition(task)

        if context.hasChanges {
            do {
                try context.save()
            } catch {
             
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func fetchData(complition: @escaping(_ tasklist: [Task]) ->Void ) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
       
        do {
           let taskList = try context.fetch(fetchRequest)
            complition(taskList)
        } catch {
            print("Faild to fetch data", error)
        }
    }
    
    
    func deleteData(task: Task) {
        let context = persistentContainer.viewContext
        
        context.delete(task)
       
                 // MARK:  delete coreData attribute
                    if context.hasChanges {
                        do {
                            print("content changed")
                            try context.save()
                        } catch {
                            let nserror = error as NSError
                            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        }
                    }
    }

}

    
    
    

