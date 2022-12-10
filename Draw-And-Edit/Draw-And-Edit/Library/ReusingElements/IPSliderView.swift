//
//  IPSliderView.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 9.12.22.
//

import Foundation
import UIKit

// TODO: Add probably a bezier path to get right shape of the slider

class IPSliderView: UISlider {
    
    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.4
        view.layer.borderColor = UIColor.darkGray.cgColor
        
        return view
    }()
    
    private let baseLayer = CAShapeLayer()
    
    var sFrame: CGRect
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        setup()
    }
    
    override init(frame: CGRect) {
        sFrame = frame
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        clear()
        buildBaseLayer()
        
        let thumb = thumbImage(radius: 25)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func clear() {
          tintColor = .clear
          maximumTrackTintColor = .clear
          backgroundColor = .clear
          thumbTintColor = .clear
      }
    
    private func buildBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.gray.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.gray.cgColor
        baseLayer.frame = sFrame
        baseLayer.cornerRadius = baseLayer.frame.height / 2
        
        layer.insertSublayer(baseLayer, at: 0)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2,
                                 width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        return thumbView.snapshot
    }
}
