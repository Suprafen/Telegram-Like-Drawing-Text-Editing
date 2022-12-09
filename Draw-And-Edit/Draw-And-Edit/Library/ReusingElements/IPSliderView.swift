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
        createThumbImageView()
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
    
    private func createThumbImageView() {
        let thumbSize = (3 * frame.height) / 4
        let thumbView = ThumbView(frame: .init(x: 0,
                                               y: 0,
                                               width: thumbSize,
                                               height: thumbSize))
        thumbView.layer.cornerRadius = thumbSize / 2
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
    }
}


final class ThumbView: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
 
    private func setup() {
        
        let dimension: CGFloat = 12
        
        let middleView = UIView(frame: .init(x: frame.midX - 6,
                                             y: frame.midY - 6,
                                             width: dimension,
                                             height: dimension))

        middleView.backgroundColor = .white
        middleView.layer.cornerRadius = dimension / 2
        
        addSubview(middleView)
    }
}

extension UIView {
 
    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
