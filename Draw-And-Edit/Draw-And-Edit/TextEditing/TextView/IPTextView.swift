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

            drawBorder()
            let borderLayer = CAShapeLayer()
            borderLayer.path = controlPath.cgPath
            borderLayer.strokeColor = UIColor.black.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
//            borderLayer.lineWidth = 5
            self.layer.addSublayer(borderLayer)

        }
        
        private func drawBorder() {
            
            let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.bounds.width, height: self.bounds.height))
            let points: (ltc: CGPoint, rtc: CGPoint, lbc: CGPoint, rbc: CGPoint) = self.getPointsFrom(rect: rect)
            
            controlPath.removeAllPoints()
            let cornerRadius: CGFloat = 10
            controlPath.move(to: CGPoint(x: points.ltc.x + cornerRadius, y: 0))
            
            controlPath.addLine(rtc: points.rtc, cornerRadius: cornerRadius)
            controlPath.addArc(rtc: points.rtc, cornerRadius: cornerRadius)
            controlPath.addLine(rbc: points.rbc, cornerRadius: cornerRadius)
            controlPath.addArc(rbc: points.rbc, cornerRadius: cornerRadius)
            controlPath.addLine(lbc: points.lbc, cornerRadius: cornerRadius)
            controlPath.addArc(lbc: points.lbc, cornerRadius: cornerRadius)
            controlPath.addLine(ltc: points.ltc, cornerRadius: cornerRadius)
            controlPath.addArc(ltc: points.ltc, cornerRadius: cornerRadius)
            controlPath.close()
            
            
            
//            UIColor.black.setStroke()
//            UIColor.clear.setFill()
            
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
