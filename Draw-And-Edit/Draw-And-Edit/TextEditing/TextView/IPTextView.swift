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

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
