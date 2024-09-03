//
//  CodeDataManager.swift
//  ToDoList
//
//  Created by Mac  on 03.09.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Model")
        persistentContainer.loadPersistentStores{ (description, error) in
            if let error = error{
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTask(title: String, taskDescription: String, isCompleted: Bool = false) -> Task?{
        let context = persistentContainer.viewContext
        let task = Task(context: context)
        task.title = title
        task.taskDescription = taskDescription
        task.isCompleted = isCompleted
        task.createdAt = Date()
        
        do{
            try context.save()
            return task
        }catch {
            print("Failed to save task: \(error)")
            return nil
        }
    }
    
    func fetchTasks() -> [Task]{
        let contex = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
            return try contex.fetch(fetchRequest)
        } catch{
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    func deleteTask(task: Task){
        let context = persistentContainer.viewContext
        context.delete(task)
        
        saveContext()
    }
}
