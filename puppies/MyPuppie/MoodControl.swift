//
//  MoodControl.swift
//  Dog
//
//  Created by Milan Kokic on 22/12/2018.
//  Copyright © 2018 USJ. All rights reserved.
//

import UIKit

@IBDesignable class MoodControl: UIStackView {
    
    private var moodButtons = [UIButton]()
    
    var mood = 0{
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var pawSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var pawCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var editable: Bool = true {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    private func setupButtons() {
        
        for button in moodButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        moodButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledPaw = UIImage(named: "orange_paw", in: bundle, compatibleWith: self.traitCollection)
        let emptyPaw = UIImage(named:"black_paw", in: bundle, compatibleWith: self.traitCollection)
        
        
        for _ in 0..<pawCount {
            
            let button = UIButton()
            
            button.isUserInteractionEnabled = editable
            button.setImage(emptyPaw, for: .normal)
            button.setImage(filledPaw, for: .selected)
            button.setImage(filledPaw, for: .highlighted)
            button.setImage(filledPaw, for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: pawSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: pawSize.width).isActive = true
            button.addTarget(self, action: #selector(MoodControl.moodButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            moodButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    @objc func moodButtonTapped(button: UIButton) {
        guard let index = moodButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(moodButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == mood {
            // If the selected star represents the current rating, reset the rating to 0.
            mood = 0
        } else {
            // Otherwise set the rating to the selected star
            mood = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in moodButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < mood
        }
    }
}
