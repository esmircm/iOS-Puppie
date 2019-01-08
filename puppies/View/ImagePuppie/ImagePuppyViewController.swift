
import UIKit

class ImagePuppyViewController: UIViewController {
    
    
    @IBOutlet weak var imagePuppy: PuppiesAsyncImage!
    var urlImagesPuppies: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePuppy.getDetailImagesPuppies(urlImages: urlImagesPuppies)

    }
    
}
