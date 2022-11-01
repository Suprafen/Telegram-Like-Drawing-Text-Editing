//
//  IPTextView.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import Foundation
import UIKit

class IPTextView: UITextView {
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
