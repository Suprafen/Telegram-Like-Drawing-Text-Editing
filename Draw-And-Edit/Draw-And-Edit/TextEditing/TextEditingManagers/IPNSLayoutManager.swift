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
//            context?.addPath(UIBezierPath(roundedRect: usedRect, cornerRadius: 7).cgPath)
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
        
        print(strokePoints)
    }
    
    func buildPath() {
        let numberOfLines = strokePoints.count
        
        for i: Int in 0..<numberOfLines {
            let currentLine: [String : CGPoint]? = strokePoints[i]
            
            guard let ltc: CGPoint = currentLine?["ltc"],
                  let rtc: CGPoint = currentLine?["rtc"],
                  let rbc: CGPoint = currentLine?["rbc"],
                  let lbc: CGPoint = currentLine?["lbc"] else { return }
            
            if numberOfLines == 1 {
                strokePath.move(to: ltc)
                strokePath.addLine(to: rtc)
                strokePath.addLine(to: rbc)
                strokePath.addLine(to: lbc)
                strokePath.addLine(to: ltc)
            }
            else {
                if i == 0 {
                    strokePath.move(to: ltc)
                    strokePath.addLine(to: rtc)
                    strokePath.addLine(to: rbc)
                    // the last rectangle
                } else if i == numberOfLines - 1 {
                    strokePath.addLine(to: rtc)
                    strokePath.addLine(to: rbc)
                    
                    var c = i
                    
                    while c > 0 {
                        let previousLine: [String : CGPoint]? = strokePoints[c]
                        
                        guard let ltc: CGPoint = previousLine?["ltc"],
                              let lbc: CGPoint = previousLine?["lbc"] else { return }
                        
                        strokePath.addLine(to: lbc)
                        strokePath.addLine(to: ltc)
                        
                        c -= 1
                    }
                } else {
                    strokePath.addLine(to: rtc)
                    strokePath.addLine(to: rbc)
                }
            }
        }
        
        strokePath.close()
    }
}
