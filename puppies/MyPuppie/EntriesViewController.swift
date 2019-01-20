//
//  EntriesViewController.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//
import UIKit
import CoreData

class EntriesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext? = nil
    var puppiesImageHelper: PuppieImageHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        puppiesImageHelper = PuppieImageHelper()
    }
    
    // Table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryToDelete = fetchedResultsController.object(at: indexPath)
            fetchedResultsController.managedObjectContext.delete(entryToDelete)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EntryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EntryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EntryTableViewCell.")
        }
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func configureCell(_ cell: EntryTableViewCell, at indexPath: IndexPath) {
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        
        cell.dateLabel.text = entry.date
        
        let photoString = entry.value(forKey: "photo") as? String
        
        cell.photoImageView.image = UIImage(named: "puppie_placeholder")
        
        if photoString != "puppie_placeholder" {
            DispatchQueue.main.async { [weak self] in
                self?.puppiesImageHelper?.loadImage(imagePath: photoString!, completion: {(image) in
                    cell.photoImageView.image = image
                })
            }
        }
        let mood = entry.value(forKey: "mood") as? Int16
        cell.moodControl.mood = Int(mood!)
    }
    
    @IBAction func unwindToEntryList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DailyEntryViewController{
            let date = sourceViewController.date
            let photo = sourceViewController.photo
            let mood = sourceViewController.mood
            let entryId = sourceViewController.entryId
            
            if let context = managedObjectContext {
                let entityDataManager = EntityDataManager(context: context)
                entityDataManager.updateEntryList(id: entryId!, date: date!, photo: photo!, mood: mood!, completion: { [weak self] in
                    DispatchQueue.main.async {
                        try? self?.managedObjectContext!.save()
                    }
                })
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
            
            let entry = fetchedResultsController.object(at: indexPath)
            entryDetailViewController.entry = entry
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    // MARK: - Fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController<EntryEntity>! = {
        
        let fetchRequest: NSFetchRequest<EntryEntity> = EntryEntity.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        
        do {
            try aFetchedResultsController.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return aFetchedResultsController
    }()
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell as! EntryTableViewCell, at: indexPath)
            }
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
}

