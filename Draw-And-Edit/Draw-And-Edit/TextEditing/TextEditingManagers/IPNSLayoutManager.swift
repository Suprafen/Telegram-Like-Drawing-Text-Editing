//
//  IPNSLayoutManager.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.12.22.
//

import UIKit
import Foundation
import CoreGraphics


class IPNSLayoutManager: NSLayoutManager {
    // 0-indexed dic that holds corresponding points udner these points keys which are hold under line's index
    // The structure is next [0 : [ltc: (x:0,y:0), rtc: (x:20,y:0), ...], ...]
    var strokePoints: [Int: [String: CGPoint]] = [:]
    
    var strokePath: UIBezierPath = UIBezierPath()
    
    var cornerRadius: CGFloat = 7
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        
        guard let textStorage = textStorage else { return }
        
        let attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        
        guard let backgroundColor = attributes[.backgroundColor] as? UIColor else { return }
        
        let restoredAlphaColor = backgroundColor.withAlphaComponent(1)
        
        restoredAlphaColor.setFill()
        
        let range = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        
        let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: origin.x, y: origin.y)
        // Since we errase all data before putting new, we don't need to calculate a number of lines
        strokePoints = [:]
        // This won't shown the last line. Smth strange happen btw.
        strokePath = UIBezierPath()
        
        self.enumerateLineFragments(forGlyphRange: glyphRange) { [weak self] rect, usedRect, textContainer, glyphRange, stop in
            
            self?.getPoints(from: usedRect)
            context?.addPath(self?.strokePath.cgPath ?? UIBezierPath().cgPath)
            context?.setFillColor(restoredAlphaColor.cgColor)
            context?.setStrokeColor(restoredAlphaColor.cgColor)
            context?.fillPath(using: .evenOdd)
            
            context?.strokePath()
            
        }
        context?.restoreGState()
    }
    
    func getPoints(from rect: CGRect) {
        
        let ltc: CGPoint = rect.origin
        let rtc: CGPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let rbc: CGPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        let lbc: CGPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        appendPointsToStrokePoints(ltc: ltc, rtc: rtc, rbc: rbc, lbc: lbc)
        
        buildPath()
        
    }
    
    func appendPointsToStrokePoints(ltc: CGPoint, rtc: CGPoint, rbc: CGPoint, lbc: CGPoint) {
        let currentIndexOfStrokePoints: Int = strokePoints.count
        
        strokePoints[currentIndexOfStrokePoints] = ["ltc": ltc, "rtc": rtc, "rbc": rbc, "lbc": lbc]
    }
    
    func buildPath() {
        let numberOfLines = strokePoints.count
        
        for i: Int in 0..<numberOfLines {
            let currentLine: [String : CGPoint]? = strokePoints[i]
            
            guard var ltc: CGPoint = currentLine?["ltc"],
                  var rtc: CGPoint = currentLine?["rtc"],
                  var rbc: CGPoint = currentLine?["rbc"],
                  var lbc: CGPoint = currentLine?["lbc"] else { return }
            
            var previousLine: [String : CGPoint]? = nil
            
            if i > 0 {
                previousLine = strokePoints[i - 1]
            }
            
            var nextLine: [String : CGPoint]? = nil
            
            if i < numberOfLines - 1 {
                nextLine = strokePoints[i + 1]
            }
            
            if numberOfLines == 1 {
                strokePath.move(to: ltc)
                
                addLine(rtc: rtc)
                addArc(rtc: rtc)
                
                addLine(rbc: rbc)
                addArc(rbc: rbc)
                
                addLine(lbc: lbc)
                addArc(lbc: lbc)
                
                addLine(ltc: ltc)
                addArc(ltc: ltc)
            }
            else {
                // MARK: The first line/rectangle
                if i == 0 {
                    guard let nextLine: [String : CGPoint] = nextLine else { return }
                    addLine(rtc: rtc)
                    addArc(rtc: rtc)
                    
                    addLine(rbc: rbc)
                    
                    if nextLine["rtc"]!.x < rtc.x {
                        // From top the left (corner inside)
                        addArc(rbc: rbc)
                        
                    } else if nextLine["rtc"]!.x > rtc.x {
                        // From top to the right (corner outside)
                        addArc(rbc: rbc, currentGreater: false)
                    }
                    
                    // MARK: The last line/rectangle
                } else if i == numberOfLines - 1 {
                    
                    guard let previousLine: [String : CGPoint] = previousLine else { return }
                    
                    addLine(lbc: rtc)
                    if previousLine["rtc"]!.x > rtc.x {
                        // From top to the left (corner outside)
                        addArc(rtc: rtc, currentGreater: false)
                    } else {
                        // From top to the rigth (corner outside)
                        addArc(rtc: rtc)
                    }
                    
                    addLine(rbc: rbc)
                    addArc(rbc: rbc)
                    
                    drawCornersForPreviousPoints(strokePoints, index: i)
                    
                } else {
                    // MARK: The right side of some middle line
                    
                    guard let previousLine: [String : CGPoint] = previousLine else { return }
                    
                    if previousLine["rtc"]!.x > rtc.x {
                        // From top to the left( corner outside )
                        addLine(rtc: rtc)
                        addArc(rtc: rtc, currentGreater: false)
                    } else {
                        // From top to the right ( corner inside )
                        addLine(rtc: rtc)
                        addArc(rtc: rtc)
                    }
                    
                    guard let nextLine: [String : CGPoint] = nextLine else { return }
                    addLine(rbc: rbc)
                    if nextLine["rtc"]!.x > rtc.x {
                        // From top to the right ( corner outside)
                        addArc(rbc: rbc, currentGreater: false)
                    } else {
                        // From top to the left ( corner inside)
                        addArc(rbc: rbc)
                    }
                }
            }
        }
        
        strokePath.close()
    }
    
    func drawCornersForPreviousPoints(_ strokePoints: [Int : [String : CGPoint]], index i: Int) {
        // i is stands for the last index of our array of points, or simply (strokePoints.count - 1)
        var c = i
        // Here we move backwards to the top
        // Start with left bottom corner:
        while c >= 0 {
            let currentLine: [String : CGPoint]? = strokePoints[c]
            // MARK: The left side of some middle line
            guard let ltc: CGPoint = currentLine?["ltc"],
                  let lbc: CGPoint = currentLine?["lbc"] else { return }
            
            var nextLine: [String : CGPoint]? = nil
            // index of next line
            let iN = c - 1
            
            if iN >= 0 {
                nextLine = strokePoints[iN]
            }
            
            var previousLine: [String : CGPoint]? = nil
            // index of previous line
            let iP = c + 1
            
            if iP <= i {
                previousLine = strokePoints[iP]
            }
            
            if c == i {
                // Keep in mind that greater line will have lower X-Axis!!!!
                addLine(lbc: lbc)
                addArc(lbc: lbc)
                
                guard let nextLine: [String : CGPoint] = nextLine else { return }
                addLine(ltc: ltc)
                    
                    if nextLine["ltc"]!.x < ltc.x {
                        // Next line is greater than current    
                        addArc(ltc: ltc, currentGreater: false)
                    } else {
                        // Next line is less than current
                        addArc(ltc: ltc)
                    }
                
            } else if c == 0 {
                // The first line/rectangle from the top.
                guard let previousLine: [String : CGPoint] = previousLine else { return }
                
                addLine(lbc: lbc)
                    
                    if previousLine["ltc"]!.x < lbc.x {
                        // Previous is bigger
                        addArc(lbc: lbc, currentGreater: false)
                    } else {
                        // Previous is less than current
                        addArc(lbc: lbc)
                    }
                
                addLine(ltc: ltc)
                addArc(ltc: ltc)
                
            } else {
                
                guard let previousLine: [String : CGPoint] = previousLine else { return }
                    
addLine(lbc: lbc)

                    if previousLine["ltc"]!.x < lbc.x {
                        // Previous line bigger than current
                        
                        addArc(lbc: lbc, currentGreater: false)
                        
                    } else {
                        // Previous line is less than current
                        addArc(lbc: lbc)
                    }
                
                guard let nextLine = nextLine else { return }

                    addLine(ltc: ltc)

                    if nextLine["ltc"]!.x < ltc.x {
                        // Next line is greater than current
                        addArc(ltc: ltc, currentGreater: false)
                        
                    } else {
                        // Next luine is less than current
                        addArc(ltc: ltc)
                    }
            }
            c -= 1
        }
    }
    
    func addLine(rtc: CGPoint) {
        strokePath.addLine(to: CGPoint(x: rtc.x - cornerRadius, y: rtc.y))
    }
    
    func addArc(rtc: CGPoint, currentGreater: Bool = true) {
        if currentGreater {
            strokePath.addArc(withCenter: CGPoint(x: rtc.x - cornerRadius,
                                                  y: rtc.y + cornerRadius), radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
        } else {
            strokePath.addArc(withCenter: CGPoint(x: rtc.x + cornerRadius,
                                                  y: rtc.y + cornerRadius), radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: false)
        }
    }
    
    func addLine(rbc: CGPoint) {
        strokePath.addLine(to: CGPoint(x: rbc.x, y: rbc.y - cornerRadius))
    }
    
    func addArc(rbc: CGPoint, currentGreater: Bool = true) {
        if currentGreater {
            strokePath.addArc(withCenter: CGPoint(x: rbc.x - cornerRadius,
                                                  y: rbc.y - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
        } else {
            strokePath.addArc(withCenter: CGPoint(x: rbc.x + cornerRadius,
                                                  y: rbc.y - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(2 * Double.pi / 4) , clockwise: false)
        }
    }
    
    func addLine(lbc: CGPoint) {
        strokePath.addLine(to: CGPoint(x: lbc.x + cornerRadius, y: lbc.y))
    }
    
    func addArc(lbc: CGPoint, currentGreater: Bool = true) {
        if currentGreater {
            strokePath.addArc(withCenter: CGPoint(x: lbc.x + cornerRadius,
                                                  y: lbc.y - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
        } else {
            strokePath.addArc(withCenter: CGPoint(x: lbc.x - cornerRadius,
                                                  y: lbc.y - cornerRadius), radius: cornerRadius, startAngle: CGFloat(2 * Double.pi / 4), endAngle: 0, clockwise: false)
        }
    }
    
    func addLine(ltc: CGPoint) {
        strokePath.addLine(to: CGPoint(x: ltc.x, y: ltc.y + cornerRadius))
    }
    
    func addArc(ltc: CGPoint, currentGreater: Bool = true) {
        if currentGreater {
            strokePath.addArc(withCenter: CGPoint(x: ltc.x + cornerRadius,
                                                  y: ltc.y + cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
        } else {
            strokePath.addArc(withCenter: CGPoint(x: ltc.x - cornerRadius, 
                                                  y: ltc.y + cornerRadius), radius: cornerRadius , startAngle: 0, endAngle: (3 * Double.pi) / 2, clockwise: false)
        }
    }
}
