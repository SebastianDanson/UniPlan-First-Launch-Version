//
//  PentagonView.swift
//  Student Schedule Planner
//
//  Created by Student on 2020-06-22.
//  Copyright © 2020 Sebastian Danson. All rights reserved.
//

import UIKit

/*
 * This View is creates a pentagon shape that is used to set the startTime
 */

class PentagonView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    var color = UIColor.clouds {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var borderColor = UIColor.silver {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let w = size.width * 0.85
        
        let p1 = CGPoint(x: 0, y: 0)
        let p2 = CGPoint(x:p1.x + w, y:p1.y)
        let p3 = CGPoint(x:size.width, y: size.height/2)
        let p4 = CGPoint(x:p2.x, y:p2.y + size.height)
        let p5 = CGPoint(x:p1.x, y:size.height)
        
        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.close()
        
        // fill the path
        color.setFill()
        borderColor.setStroke()
        
        path.lineWidth = 2
        path.fill()
        path.stroke()
    }
}
