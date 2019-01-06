
import UIKit

class ListPuppiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var PuppiesCollectionView: UICollectionView!
    private var puppiesService: PuppiesService?
    var puppies: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PuppiesCollectionView.delegate = self
        PuppiesCollectionView.dataSource = self
        
        getListPuppies()
    }
    
    private func getListPuppies() {
        
        guard puppiesService == nil else { return }
        
        puppiesService = PuppiesService()
        PuppiesService().getListPuppies { [weak self] (puppies) in
            
            DispatchQueue.main.async {
                self?.PuppiesCollectionView?.reloadData()
                self?.puppiesService = nil
            }
            
            if puppies != nil {
                self?.puppies = puppies
            }
            
        }
  
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puppies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListPuppiesCollectionViewCell
        
        let puppieName = self.puppies![indexPath.item]
        
        cell.layer.cornerRadius = 10
        cell.labelPuppie.text = puppieName
        cell.imagePuppie.getImageRandomPuppies(puppieName: puppieName)
        cell.imagePuppie.alpha = 0.65
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width * 0.95, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPuppiesList" {
            if let nav = segue.destination as? UINavigationController,
                let detail = nav.topViewController as? DetailListPuppiesViewController,
                let sender = sender as? UICollectionViewCell,
                let indexPath = self.PuppiesCollectionView.indexPath(for: sender) {
                
                    detail.puppieName = puppies![indexPath.item]
                
                }
            }
    }
    
}


