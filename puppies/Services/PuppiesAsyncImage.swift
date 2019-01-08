
import UIKit

class PuppiesAsyncImage: UIImageView {
    
    var lastMark: UUID? = nil // variable para comprobar ultima petición al cache
    
    func getImageRandomPuppies(puppieName: String) {
        
        let urlImageRandom = URLRequest(url: URL(string: "https://dog.ceo/api/breed/\(puppieName.lowercased())/images/random")!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = URLSession.shared.dataTask(with: urlImageRandom) {
            (data, response, error) in
            
            guard error == nil && data != nil else {
                print("error al llamar el servicio")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let subJson = json["message"] as! String
                
                if let urlImage = URL(string: subJson) {
                
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: urlImage) {
                            if let image = UIImage(data: data) {
                                
                                DispatchQueue.main.async {
                                    
                                    let resizeImage = self.resizeImage(image: image, newWidth: 500)
                                    
                                    self.image = resizeImage
       
                                }

                            }
                        }
                    }
                }
                
            } catch {
                print("error when calling image list of puppies")
            }
            
        }
        
        task.resume()
    
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getDetailImagesPuppies(urlImages: String) {
        
        let mark = UUID() // creando intancia
        
        self.lastMark = mark
        
        if let urlImage = URL(string: urlImages) {
        
            ImageCache.shared.imageWithURL(urlImage) { [weak self] (image) in
                
                guard self?.lastMark == mark else { // comprobando ultima petición al cache
                    return
                }
                
                guard image != nil else { return }
                
                if Thread.isMainThread { // pregunto si estoy en el hilo principal
                    
                    self?.image = image!
                    
                } else { // sino hago un dispatch al hilo principal
                    
                    DispatchQueue.main.async {
                        self?.image = image!
                    }
                }
            }
        }
        
    }
    
}
