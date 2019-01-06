
import UIKit

class ImageCache {
    
    let memCache = NSCache<NSString, UIImage>()
    static let shared = ImageCache();
    
    func imageWithURL(_ url: URL, completation: @escaping (UIImage?) -> Void) {
        
        if let image = memCache.object(forKey: url.absoluteString as NSString) { // buscammos img en cache
            
            completation(image) // si existe retorna la img
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            let fileManager = FileManager.default
            
            if let docs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first { // instanciando sistema de ficheros
                
                let file = docs.appendingPathComponent(url.lastPathComponent)
                
                if let image = UIImage(contentsOfFile: file.path) { // buscando imagen en sistema de fichero
                    
                    completation(image)
                    
                    self?.memCache.setObject(image, forKey: url.absoluteString as NSString) // guardando en memoria
                    
                    return
                }
            }
            
            self?.downloadImage(url, completion: completation)
        }
    }
    
    private func downloadImage(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { // descargado datos desde la url
            [weak self] (data, response, error) in
            
            guard error == nil && data != nil else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data:data!) {
                
                completion(image)
                
                self?.memCache.setObject(image, forKey: url.absoluteString as NSString) // guardando en memoria
                
                let fm = FileManager.default
                
                if let docs = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
                    
                    let file = docs.appendingPathComponent(url.lastPathComponent)
                    
                    if let data = image.pngData() {
                        try? data.write(to: file) // guardando en sistema de ficheros
                    }
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
