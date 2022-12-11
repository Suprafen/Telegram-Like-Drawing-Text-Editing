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
        
        self.enumerateLineFragments(forGlyphRange: glyphRange) { rect, usedRect, textContainer, glyphRange, stop in
            context?.addPath(UIBezierPath(roundedRect: usedRect, cornerRadius: 7).cgPath)
            
            context?.setFillColor(restoredAlphaColor.cgColor)
            context?.setStrokeColor(restoredAlphaColor.cgColor)
            context?.fillPath(using: .evenOdd)
            
            context?.strokePath()
            
        }
        context?.restoreGState()
    }
}
