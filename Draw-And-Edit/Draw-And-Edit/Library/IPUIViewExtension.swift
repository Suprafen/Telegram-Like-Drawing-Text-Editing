//
//  IPUIViewExtension.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 3.11.22.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
            guard !isFirstResponder else { return self }
            
            for subview in self.subviews {
                if let firstREsponder = subview.firstResponder {
                    return firstREsponder
                }
            }
        return nil
    }
}
