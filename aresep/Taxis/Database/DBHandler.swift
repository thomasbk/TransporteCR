//
//  DBHandler.swift
//  aresep
//
//  Created by Pro Retina on 4/16/18.
//  Copyright © 2018 SOIN. All rights reserved.
//

import UIKit

class DBHandler: NSObject {
    
    
    var users: [NSManagedObject] = []
    var managedContext: NSManagedObjectContext!
    
    
    func isUserRegistered () -> Bool {
        
        var result = false
        
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            users = try managedContext.fetch(fetchRequest)
            if (users.count > 0) {
                result = true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    
    func registerUser (name:String, id:String, email:String) -> Bool {
        
        var result = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(String(name), forKeyPath: "name")
        person.setValue(String(id), forKeyPath: "id")
        person.setValue(String(email), forKeyPath: "email")
        
        
        // 4
        do {
            try managedContext.save()
                result = true
            
            //trips.append(trip)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    
    
    class func setStarRating (id:Int, ratingSelected:Int) -> Bool {
        
        var result = false
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.managedObjectContext!
        
        var ratings: [NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rating")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            ratings = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let rating = ratings[0]
        rating.setValue(ratingSelected, forKeyPath: "value")
        
        do {
            try managedContext.save()
            result = true
            
            //trips.append(trip)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    
    class func getUserID () -> String {
        
        var managedContext: NSManagedObjectContext!
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return ""
        }
        
        managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        
        var users: [NSManagedObject] = []
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let user = users[0]
        let userID = user.value(forKeyPath: "id") as! String
        
        return userID
    }
    
    
    // guardar el json de un viaje
    class func saveTripData (tripData: String, id:Int) -> Bool {
        
        var result = false
        print("Saved trip: \(tripData)")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entity(forEntityName: "SentTrip", in: managedContext)!
        let trip = NSManagedObject(entity: entity, insertInto: managedContext)
        
        trip.setValue(id, forKeyPath: "id")
        trip.setValue(tripData, forKeyPath: "tripData")
        trip.setValue(false, forKeyPath: "state")
        
        do {
            try managedContext.save()
            result = true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    
    
    // obtener jsons no enviados
    class func loadSavedTripData () -> [NSManagedObject] {
        
        var results:[NSManagedObject] = [NSManagedObject]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return results
        }
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SentTrip")
        
        do {
            results = try managedContext.fetch(fetchRequest)
            //for trip in trips {
            //    result.append(trip.value(forKey: "tripData") as! String)
            //}
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return results
    }
    
    //
    class func deleteSavedTripData (id:Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SentTrip")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let trips = try managedContext.fetch(fetchRequest)
            for trip in trips {
                
                managedContext.delete(trip)
                
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    class func deleteAllSavedTripData () {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.managedObjectContext!
    
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SentTrip")
    
        if #available(iOS 9.0, *) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
            do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
            } catch {
                print ("There was an error")
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    class func getNumberOfRatings () -> Int {
        
        var result = 0
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return result
        }
        
        var managedContext: NSManagedObjectContext!
        managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Rating")
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            let ratings = try managedContext.fetch(fetchRequest)
            result = ratings.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    

}
