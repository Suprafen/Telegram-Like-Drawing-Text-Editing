//
//  ViewToImageExtension.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 10.12.22.
//

import Foundation
import UIKit

extension UIView {
 
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
    
}
