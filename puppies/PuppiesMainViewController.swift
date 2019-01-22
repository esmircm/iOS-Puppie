//
//  PuppiesMain.swift
//  puppies
//
//  Created by Milan Kokic on 04/01/2019.
//  Copyright © 2019 Endalia Sistemas. All rights reserved.
//

import UIKit

class PuppiesMainViewController: UIViewController {
    
    @IBOutlet weak var myPuppieButton: UIButton!
    @IBOutlet weak var puppiesButton: UIButton!
    @IBOutlet weak var moodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPuppieButton.layer.cornerRadius = 12
        myPuppieButton.layer.borderWidth = 0
        myPuppieButton.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIButton.animate(withDuration: 0.7, animations: {
            self.myPuppieButton.layer.transform = CATransform3DMakeScale(1.25,1.25,1)
        },completion: { finished in
            UIButton.animate(withDuration: 0.5, animations: {
                self.myPuppieButton.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
        
        puppiesButton.layer.cornerRadius = 12
        puppiesButton.layer.borderWidth = 0
        puppiesButton.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIButton.animate(withDuration: 0.5, animations: {
            self.puppiesButton.layer.transform = CATransform3DMakeScale(1.25,1.25,1)
        },completion: { finished in
            UIButton.animate(withDuration: 0.3, animations: {
                self.puppiesButton.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
        
        moodButton.layer.cornerRadius = 12
        moodButton.layer.borderWidth = 0
        moodButton.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIButton.animate(withDuration: 0.5, animations: {
            self.moodButton.layer.transform = CATransform3DMakeScale(1.25,1.25,1)
        },completion: { finished in
            UIButton.animate(withDuration: 0.2, animations: {
                self.moodButton.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        })
    
    }
}
