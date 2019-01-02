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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PuppiesCollectionView.delegate = self
        PuppiesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListPuppiesCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.labelPuppie.text = "Affenpinscher"
        cell.imagePuppie.image = UIImage(named: "1")
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

