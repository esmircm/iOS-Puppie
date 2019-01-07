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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = getEntries()
    }
    
    func getEntries() -> [Entry]{
        // fetchData
        var entriesData: [NSManagedObject] = []
        var entries: [Entry] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EntryEntity")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            entriesData = result as! [NSManagedObject]
        } catch {
            
            print("Failed")
        }
        
        for entryData in entriesData {
            let id = entryData.value(forKeyPath: "id") as? String
            let date = entryData.value(forKeyPath: "date") as? String
            let photoString = entryData.value(forKeyPath: "photo") as? String
            let moodControl = entryData.value(forKeyPath: "mood") as? Int ?? 0
            entries.append(Entry(id: id!, date: date!, photo: photoString!, mood: moodControl)!)
        }
        
        return entries
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entry = entries[indexPath.row]
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EntryEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", entry.id)
            do {
                let entriesData = try context.fetch(fetchRequest)
                
                let entryDelete = entriesData [0] as! NSManagedObject
                context.delete(entryDelete)
                
            } catch {
                print("Error")
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            
            entries.remove(at: indexPath.row)
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
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(photoString)
                cell.photoImageView.image = UIImage(contentsOfFile: imageURL.path)
            } else {
                cell.photoImageView.image = UIImage(named: "orange_paw")
            }
        } else {
            cell.photoImageView.image = UIImage(named: "orange_paw")
        }
        cell.moodControl.mood = entry.mood
        
        return cell
    }
    
    @IBAction func unwindToEntryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DailyEntryViewController, let entry = sourceViewController.entry {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "EntryEntity", in: context)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                entries[selectedIndexPath.row] = entry
                
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EntryEntity")
                fetchRequest.predicate = NSPredicate(format: "id = %@", entry.id)
                do {
                    let entriesData = try context.fetch(fetchRequest)
                    
                    let entryUpdate = entriesData [0] as! NSManagedObject
                    entryUpdate.setValue(entry.date, forKey: "date")
                    entryUpdate.setValue(entry.mood, forKey: "mood")
                    entryUpdate.setValue(entry.photo, forKey: "photo")
                    
                } catch {
                    print("Error")
                }
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                // add Entry
                let newEntry = NSManagedObject(entity: entity!, insertInto: context)
                newEntry.setValue(entry.id, forKey: "id")
                newEntry.setValue(entry.date, forKey: "date")
                newEntry.setValue(entry.mood, forKey: "mood")
                newEntry.setValue(entry.photo, forKey: "photo")
                
                let newIndexPath = IndexPath(row: entries.count, section: 0)
                entries.append(entry)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
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
