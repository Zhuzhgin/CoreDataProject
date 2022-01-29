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
    private let context: NSManagedObjectContext
    
   
    private init() {
              context = persistentContainer.viewContext
          }

    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataProject")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
   
    func saveTask (taskName: String, complition: @escaping(_ task: Task) -> Void) {
        let task = Task(context: context)
        
        task.name = taskName
        complition(task)
        
        saveContext()
    }
    
    func edit(task: Task, newName: String){
      
        task.name = newName
        saveContext()
    }
    
    
    func fetchData(complition: @escaping(_ tasklist: [Task]) ->Void ) {

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let taskList = try context.fetch(fetchRequest)
            complition(taskList)
        } catch {
            print("Faild to fetch data", error)
        }
    }
    
    func deleteData(task: Task) {
        
        context.delete(task)
        saveContext()
    }
    
    private func saveContext() {
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

    
    
    

