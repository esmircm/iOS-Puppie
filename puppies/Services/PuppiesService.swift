
import Foundation

struct PuppiesService {
    
    private let urlListPuppies = "https://dog.ceo/api/breeds/list/all"
    
    func getListPuppies(completation:@escaping ([String]?) -> Void) {
        
        let url = URLRequest(url: URL(string: urlListPuppies)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard error == nil && data != nil else {
                completation(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let subJson = json["message"] as! [ String: Any ]
                
                let listPuppies = [String] (subJson.keys)
                
                DispatchQueue.main.async {
                    completation(listPuppies)
                }
                
            } catch {
                print("error when calling list of puppies")
            }
            
        }
        
        task.resume()
        
    }
    
    func getUrlImagesPuppies(_ puppieName: String, completation:@escaping ([String]?) -> Void) {
        
        let url = URLRequest(url: URL(string: "https://dog.ceo/api/breed/\(puppieName)/images")!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            guard error == nil && data != nil else {
                completation(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let urlImagesPuppies = json["message"] as! [String]
                
                DispatchQueue.main.async {
                    completation(urlImagesPuppies)
                }
                
            } catch {
                print("error when calling images of puppies")
            }
            
        }
        
        task.resume()
        
    }
    
}
