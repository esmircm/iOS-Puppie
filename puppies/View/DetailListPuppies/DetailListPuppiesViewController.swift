
import UIKit

class DetailListPuppiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var ListPuppiesCollectionView: UICollectionView!
    var puppieName: String?
    var puppies: [String]?
    private var puppiesService: PuppiesService?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ListPuppiesCollectionView.delegate = self
        ListPuppiesCollectionView.dataSource = self
        
        
        getImagesPuppies()
    }
    
    private func getImagesPuppies() {
        
        guard puppiesService == nil else { return }
        
        puppiesService = PuppiesService()
        PuppiesService().getUrlImagesPuppies(puppieName!) { [weak self] (puppies) in
            
            DispatchQueue.main.async {
                self?.ListPuppiesCollectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPuppies", for: indexPath) as! DetailListPuppiesCollectionViewCell
        
        let urlImagesPuppies = puppies![indexPath.item]
        
        cell.layer.cornerRadius = 10
        cell.imagePuppies.getDetailImagesPuppies(urlImages: urlImagesPuppies)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowImagePuppies" {
            if let nav = segue.destination as? UINavigationController,
                let detail = nav.topViewController as? ImagePuppyViewController,
                let sender = sender as? UICollectionViewCell,
                let indexPath = self.ListPuppiesCollectionView.indexPath(for: sender) {
                
                detail.urlImagesPuppies = puppies![indexPath.item]
                
            }
        }
    }
    

}
