
import UIKit
import CoreData

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var basicBarChart: BasicBarChart!
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let entryChartDataHelper = EntryChartDataHelper()
        
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EntryEntity")
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] asynchronousFetchResult in
            
            // Retrieves an array of entry entities from the fetch result `finalResult`
            guard let result = asynchronousFetchResult.finalResult as? [EntryEntity] else { return }
            
            let dataEntries = entryChartDataHelper.getSortedData(entries: result)
            
            DispatchQueue.main.async { [weak self] in
                self?.basicBarChart.dataEntries = dataEntries
            }
        }
        
        do {
            // Executes `asynchronousFetchRequest`
            try managedObjectContext!.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
    }
}
