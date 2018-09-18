//
//  PushButtonView.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/24/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit


//@IBDesignable

class PushButtonView: UIButton {
    
    
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = false

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        
        if isAddButton {
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        
        
            //vertical line code moveToPoint(_:) and addLineToPoint(_:)
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
            
        
        
        //set the stroke color
        UIColor.white.setStroke()
        
        //draw the stroke
        plusPath.stroke()
        
        }
        
    }
 

}
