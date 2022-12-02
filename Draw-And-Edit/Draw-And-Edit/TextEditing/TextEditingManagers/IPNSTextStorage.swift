//
//  IPNSTextStorage.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 2.12.22.
//

import Foundation
import UIKit

class IPNSTextStorage: NSTextStorage {
    
    var backingStorage: NSMutableAttributedString
    
    override init() {
        
        backingStorage = NSMutableAttributedString()
        super.init()

    }

    override init(attributedString attrStr: NSAttributedString) {

        backingStorage = NSMutableAttributedString(attributedString: attrStr)
        super.init(attributedString: attrStr)
        
    }
    
    required init?(coder: NSCoder) {
        backingStorage = NSMutableAttributedString()
        super.init(coder: coder)
    }
    
    override var string: String {
        self.backingStorage.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        backingStorage.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        backingStorage.replaceCharacters(in: range, with: str)
              self.edited(.editedCharacters,
                          range: range,
                          changeInLength: str.count - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {

           backingStorage.setAttributes(attrs, range: range)
           self.edited(.editedAttributes,
                       range: range,
                       changeInLength: 0)
       }
    
}
