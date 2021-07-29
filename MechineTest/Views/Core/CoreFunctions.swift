//
//  CoreFunctions.swift
//  MechineTest
//
//  Created by Mani on 3/12/21.
//

import Foundation
import UIKit
import CoreData

func save(data:Datum) {
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    // 1
    let managedContext =
        appDelegate.persistentContainer.viewContext
    // 2
    let task_Entity =
        NSEntityDescription.entity(forEntityName: "User",
                                   in: managedContext)!
    let task_Object = NSManagedObject(entity: task_Entity,
                                      insertInto: managedContext)
    // 3
    task_Object.setValue(data.avatar, forKeyPath: "avatar")
    task_Object.setValue(data.id, forKeyPath: "id")
    task_Object.setValue(data.email, forKeyPath: "email")
    task_Object.setValue(data.firstName, forKeyPath: "firstName")
    task_Object.setValue(data.lastName, forKeyPath: "lastName")
    // 4
    do {
        try managedContext.save()
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}


func retrieve_data(){
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    // 1
    let managedContext =
        appDelegate.persistentContainer.viewContext
    //2
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    //3
    do {
        Singleton.shared.userDetail.removeAll()
        let people = try managedContext.fetch(fetchRequest)
        _ = people.map {  Singleton.shared.userDetail.append(Datum(avatar: $0.value(forKey: "avatar") as? String, email: $0.value(forKey: "email") as? String, firstName: $0.value(forKey: "firstName") as? String, id: $0.value(forKey: "id") as? Int, lastName: $0.value(forKey: "lastName") as? String))   }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
}
