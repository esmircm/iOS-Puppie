//
//  ImagePuppyViewController.swift
//  puppies
//
//  Created by Esmir Cabrera on 2/1/19.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class ImagePuppyViewController: UIViewController {
    
    
    @IBOutlet weak var imagePuppy: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePuppy.image = UIImage(named: "1")

        // Do any additional setup after loading the view.
    }
    
}
