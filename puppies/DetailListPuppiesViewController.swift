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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellPuppies", for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    

}
