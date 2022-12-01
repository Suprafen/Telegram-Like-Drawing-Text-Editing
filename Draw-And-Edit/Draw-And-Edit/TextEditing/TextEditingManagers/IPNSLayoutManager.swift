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
        
        self.enumerateLineFragments(forGlyphRange: glyphsToShow) { rect, usedRect, textContainer, range, stop in
            
            let currentContext = UIGraphicsGetCurrentContext()
            currentContext?.saveGState()
            
            currentContext?.setFillColor(UIColor.black.cgColor)
            currentContext?.restoreGState()

        }
    }
}
