//
//  ListPuppiesViewController.swift
//  puppies
//
//  Created by Endalia Sistemas on 1/2/19.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class DetailListPuppiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var ListPuppiesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ListPuppiesCollectionView.delegate = self
        ListPuppiesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPuppies", for: indexPath) as! DetailListPuppiesCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.imagePuppies.image = UIImage(named: "1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    

}
