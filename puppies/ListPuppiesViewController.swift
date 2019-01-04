//
//  ViewController.swift
//  puppies
//
//  Created by Endalia Sistemas on 1/2/19.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class ListPuppiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var PuppiesCollectionView: UICollectionView!
    private let urlString = "https://dog.ceo/api/breeds/list/all"
    var puppies: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PuppiesCollectionView.delegate = self
        PuppiesCollectionView.dataSource = self
        
        getListPuppies()
    }
    
    private func getListPuppies() {
        
        let session = URLSession.shared
        
        let req = URLRequest(url: URL(string: urlString)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = session.dataTask(with: req) {
            (data, response, error) in
            
            guard error == nil && data != nil else {
                print("error al llamar el servicio")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let subJson = json["message"] as! [String:Any]
                
                let listPuppies = [String] (subJson.keys)
                
                DispatchQueue.main.async {
                    print("codigo en el hilo principal")
                    self.puppies = listPuppies
                    self.PuppiesCollectionView?.reloadData()
                }
                
                print(listPuppies)
            } catch {
                
            }

        }
        
        task.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 50
        return puppies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListPuppiesCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.labelPuppie.text = self.puppies![indexPath.item]
        
        //cell.imagePuppie = nil
        
        let session = URLSession.shared
        
        let req = URLRequest(url: URL(string: "https://dog.ceo/api/breed/\(self.puppies![indexPath.item].lowercased())/images/random")!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 0.0)
        
        let task = session.dataTask(with: req) {
            (data, response, error) in
            
            guard error == nil && data != nil else {
                print("error al llamar el servicio")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                
                let subJson = json["message"] as! String
                
                let req2 = URL(string: subJson)!
                
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: req2) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                //cell.imagePuppie.image = UIImage(named: image)
                                cell.imagePuppie.image = image
                            }
                        }
                    }
                }
                
//                DispatchQueue.main.async {
//                    print("codigo en el hilo principal")
//                    cell.imagePuppie.image = UIImage(named: subJson2)
//                    //self.PuppiesCollectionView?.reloadData()
//                }
                
                //print(subJson)
            } catch {
                
            }
            
        }
        
        task.resume()
        
        //cell.imagePuppie.image = UIImage(named: "1")
        cell.imagePuppie.alpha = 0.45
        
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
        
        if segue.identifier == "ShowPuppiesList"
        {
            
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailListPuppiesViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
            
        }
    }

}

