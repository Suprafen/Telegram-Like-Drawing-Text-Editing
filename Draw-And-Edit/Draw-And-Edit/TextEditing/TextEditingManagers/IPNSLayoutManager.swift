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
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
   
        let range = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        
        let glyphRange = self.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        
        UIColor.systemOrange.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: origin.x, y: origin.y)
        
        self.enumerateLineFragments(forGlyphRange: glyphRange) { rect, usedRect, textContainer, glyphRange, stop in
            context?.addPath(UIBezierPath(roundedRect: usedRect, cornerRadius: 7).cgPath)
            
            context?.setFillColor(UIColor.red.cgColor)
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.fillPath(using: .evenOdd)
            
            context?.strokePath()
            
        }
        context?.restoreGState()
    }
}
