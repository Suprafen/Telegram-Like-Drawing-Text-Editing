//
//  IPTextView.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import Foundation
import UIKit

class IPTextView: UITextView {
    // TODO: Refactor IPMapViewController and move the code that responsible for filling to this propperty
    // Make the property computed, obviously
    var textFillState: IPTextFillState = .defaultFill

    var textAlignmentState: IPTextAlignmentState = .left {
        didSet {
            switch textAlignmentState {
            case .left:
                self.textAlignment = .left
            case .center:
                self.textAlignment = .center
            case .right:
                self.textAlignment = .right
            }
        }
    }

    let controlPath = UIBezierPath()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
// Drawing border related
extension IPTextView {
    
    // To add a border that bigger than text view frame and has two circles that must be interactive
    // to drag on these two circles frame of the text view must be changed
    
    // To add a touch gesture that will present a menu with three options edit, delete, copy
    // we need to override some method

        func showBorderWithCircles() {
            self.setupCALayer()
            // self.drawCircles()
        }

        private func setupCALayer() {
            self.backgroundColor = .systemOrange
            
            let borderLayer = CAShapeLayer()
            let pth = drawBorder()
            borderLayer.path = pth.cgPath
            borderLayer.lineWidth = 4
            borderLayer.strokeColor = UIColor.black.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor

            self.layer.addSublayer(borderLayer)
            borderLayer.position = CGPoint(x: 4, y: 4)
        }
        
        private func drawBorder() -> UIBezierPath {
            let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.frame.width - 8, height: self.frame.height - 8))
            
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
            path.stroke()
            return path
        }

        private func drawCircles() {
            let circle1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            circle1.backgroundColor = .red
            circle1.layer.cornerRadius = 10
            circle1.layer.borderWidth = 2
            circle1.layer.borderColor = UIColor.black.cgColor
            circle1.isUserInteractionEnabled = true
            self.addSubview(circle1)

            let circle2 = UIView(frame: CGRect(x: self.bounds.width - 20, y: self.bounds.height - 20, width: 20, height: 20))
            circle2.backgroundColor = .red
            circle2.layer.cornerRadius = 10
            circle2.layer.borderWidth = 2
            circle2.layer.borderColor = UIColor.black.cgColor
            circle2.isUserInteractionEnabled = true
            self.addSubview(circle2)
        }

        private func getPointsFrom(rect: CGRect) -> (ltc: CGPoint, rtc: CGPoint, lbc: CGPoint, rbc: CGPoint) { 
            let ltc = CGPoint(x: rect.minX, y: rect.minY)
            let rtc = CGPoint(x: rect.maxX, y: rect.minY)
            let lbc = CGPoint(x: rect.minX, y: rect.maxY)
            let rbc = CGPoint(x: rect.maxX, y: rect.maxY)

            return (ltc, rtc, lbc, rbc)
        }
}
