//
//  EntriesViewController.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//
import UIKit
import CoreData

class EntriesViewController: UITableViewController {
    
    var entries: [Entry] = []
    var entryEntities: [EntryEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEntries()
    }
    
    func getEntries(){
        // fetchData
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntryEntity")
        let privateManagedObjectContext = getPersistentContainer().viewContext
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self ] asynchronousFetchResult in
            
            guard let entriesData = asynchronousFetchResult.finalResult as? [EntryEntity] else { return }
            self?.entryEntities = entriesData
            
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async { [weak self] in
                for entryData in entriesData {
                    let date = entryData.value(forKeyPath: "date") as? String
                    let photoString = entryData.value(forKeyPath: "photo") as? String
                    let moodControl = entryData.value(forKeyPath: "mood") as? Int ?? 0
                    self?.entries.append(Entry(date: date!, photo: photoString!, mood: moodControl)!)
                    self?.tableView.reloadData()
                }
            }
        }
        
        do {
            try privateManagedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
    }
    
    func getPersistentContainer() -> NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = getPersistentContainer().viewContext
            let entryToDelete: EntryEntity = entryEntities[indexPath.row]
            getPersistentContainer().performBackgroundTask { _ in
                
                do {
                    context.delete(entryToDelete)
                    try context.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            
            entries.remove(at: indexPath.row)
            entryEntities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EntryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EntryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EntryTableViewCell.")
        }
        
        let entry = entries[indexPath.row]
        cell.dateLabel.text = entry.date
        
        if let photoString = entry.photo {
            DispatchQueue.global(qos: .background).async {
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first {
                    
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(photoString)
                    let image  = UIImage(contentsOfFile: imageURL.path) 
                    
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                }
            }
        }
        cell.moodControl.mood = entry.mood
        
        return cell
    }
    
    @IBAction func unwindToEntryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DailyEntryViewController, let entry = sourceViewController.entry {
            
            
            let context = getPersistentContainer().viewContext
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let entryToUpdate = entryEntities[selectedIndexPath.row]
                
                getPersistentContainer().performBackgroundTask { _ in
                    
                    guard let entryToUpdateEntity = context.object(with: entryToUpdate.objectID) as? EntryEntity else { return }
                    
                    entryToUpdateEntity.date = entry.date
                    entryToUpdateEntity.mood = Int16(entry.mood)
                    entryToUpdateEntity.photo = entry.photo
                    
                    do {
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                
                entries[selectedIndexPath.row] = entry
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                let newEntry = EntryEntity(context: context)
                newEntry.setValue(entry.date, forKey: "date")
                newEntry.setValue(entry.mood, forKey: "mood")
                newEntry.setValue(entry.photo, forKey: "photo")
                
                getPersistentContainer().performBackgroundTask { _ in
                    
                    do {
                        // Saves the entries created in the `forEach`
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
                let newIndexPath = IndexPath(row: entries.count, section: 0)
                entries.append(entry)
                entryEntities.append(newEntry)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? "") {
        case "AddItem":
            print("Add Item")
            
        case "ShowEntryDetails":
            guard let entryDetailViewController = segue.destination as? DailyEntryViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEntryCell = sender as? EntryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEntryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEntry = entries[indexPath.row]
            
            entryDetailViewController.entry = selectedEntry
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
}
