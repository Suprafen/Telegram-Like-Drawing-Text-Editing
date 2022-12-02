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
        
        self.enumerateLineFragments(forGlyphRange: glyphsToShow) { (rect, usedRect, textContainer, glyphRange, stop) in

                   var lineRect = usedRect
                   lineRect.size.height = 30.0

                   let currentContext = UIGraphicsGetCurrentContext()
                   currentContext?.saveGState()

                   currentContext?.setStrokeColor(UIColor.red.cgColor)
                   currentContext?.setLineWidth(1.0)
                   currentContext?.stroke(lineRect)

                   currentContext?.restoreGState()
            
        }
    }
}
