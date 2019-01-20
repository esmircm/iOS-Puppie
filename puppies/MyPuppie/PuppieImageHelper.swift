//
//  PuppieImageLoader.swift
//  puppies
//
//  Created by Milan Kokic on 20/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class PuppieImageHelper {
    
    func loadImage(imagePath: String, completion: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { 
            var imageUrl: URL?
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath          = paths.first {
                imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imagePath)
                if imageUrl != nil {
                    if let image = UIImage(contentsOfFile: imageUrl!.path){
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
}
