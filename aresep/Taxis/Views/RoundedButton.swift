//
//  RoundedButton.swift
//  GMaps
//
//  Created by Novacomp on 2/9/18.
//  Copyright © 2018 Novacomp. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        //self.backgroundColor = .clear
        self.layer.cornerRadius = rect.size.width
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    

}
