

import UIKit

class PuppieImageHelper {
    
    func loadImage(imagePath: String, resize: Bool, completion: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { 
            var imageUrl: URL?
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first {
                imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imagePath)
                if imageUrl != nil {
                    if let imageFromFile = UIImage(contentsOfFile: imageUrl!.path){
                        let size = resize ? 200 : 500
                        let image =  self.resizeImage(image: imageFromFile, targetSize: CGSize(width: size, height: size))
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    func saveImage(data: Data, path: String){
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(path)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("Image Added Successfully")
            } catch {
                print(error)
            }
        } else {
            print("Image Not Added")
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
