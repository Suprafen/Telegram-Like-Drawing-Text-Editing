//
//  TestVC.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 10.12.22.
//

import Foundation
import UIKit
import CoreGraphics

class TestVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layer = CAShapeLayer()
        
//        let dimension: (width: Int, height: Int) = (27, 27 * 10 / 1)
        let dimension = widthToDimensions(27)
        let rect = UIView(frame: CGRect(x: 50, y: 100,
                                        width: dimension.width,
                                        height: dimension.height))
        
        rect.layer.borderColor = UIColor.black.cgColor
//        rect.layer.borderWidth = 1
        
        layer.path = createBezierPath(rect: rect.bounds).cgPath
        
        layer.strokeColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.fillColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.lineWidth = 1.0
        
        rect.layer.addSublayer(layer)
        
//        view.layer.addSublayer(layer)
        
        view.addSubview(rect)
//        layer.frame = view.frame
        
    }
    
    // Rect in which path will be placed
    func createBezierPath(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let minX = rect.minX
        let minY = rect.minY
        
        let maxX = rect.maxX
        let maxY = rect.maxY
        
        let centerY = maxY / 2
        
        let leftArcRadius = maxX * 0.01
        
        let leftArcPivot = leftArcRadius
        
        let rightArcRadius = maxY / 2
        
        path.move(to: CGPoint(x: minX, y: centerY))
        // top left arc
        path.addArc(withCenter: CGPoint(x: leftArcPivot, y: centerY),
                    radius: leftArcRadius,
                    startAngle: Double.pi,
                    endAngle: Double.pi * 3 / 2,
                    clockwise: true)
        // top line
        path.addLine(to: CGPoint(x: maxX - rightArcRadius, y: minY))
        // rigth arc
        path.addArc(withCenter: CGPoint(x: maxX - rightArcRadius, y: centerY),
                    radius: rightArcRadius,
                    startAngle: Double.pi * 3 / 2,
                    endAngle: Double.pi / 2,
                    clockwise: true)
        // bottom line
        path.addLine(to: CGPoint(x: leftArcPivot, y: centerY + leftArcPivot))
        // bottom left arc
        path.addArc(withCenter: CGPoint(x: leftArcPivot, y: centerY),
                    radius: leftArcRadius,
                    startAngle: Double.pi / 4,
                    endAngle: Double.pi,
                    clockwise: true)

        path.close()
        
        UIColor.black.setFill()
        
        UIColor.black.setStroke()
        
        path.fill()
        
        path.stroke()
        
        return path
    }
    
}

