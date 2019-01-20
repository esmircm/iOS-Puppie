//
//  EntityDataManager.swift
//  puppies
//
//  Created by Milan Kokic on 19/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import CoreData

class EntityDataManager {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func updateEntryList(id: UUID, date: String, photo: String, mood: Int, completion:@escaping ()->Void) {
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.context
        
        context.perform {
            
            let req = EntryEntity.fetchRequest() as NSFetchRequest<EntryEntity>
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            if let result = try? context.fetch(req),
                result.count > 0 {
                
                let entryToUpdateEntity = result[0]
                entryToUpdateEntity.date = date
                entryToUpdateEntity.mood = Int16(mood)
                entryToUpdateEntity.photo = photo
                
            }  else {
                if let newEntry = NSEntityDescription.insertNewObject(forEntityName: "EntryEntity", into: context) as? EntryEntity {
                    newEntry.setValue(id, forKey: "id")
                    newEntry.setValue(date, forKey: "date")
                    newEntry.setValue(mood, forKey: "mood")
                    newEntry.setValue(photo, forKey: "photo")
                }
            }
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            completion()
        }
    }
}
