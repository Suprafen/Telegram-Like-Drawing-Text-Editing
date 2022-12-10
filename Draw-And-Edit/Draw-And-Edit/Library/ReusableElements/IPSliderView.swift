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
        view.layer.borderWidth = 4
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
        
        let thumb = thumbImage(radius: sFrame.height)
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
        baseLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        baseLayer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        baseLayer.path = createBackground(rect: sFrame).cgPath
        
        layer.addSublayer(baseLayer)
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
    
    func createBackground(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        let minX = rect.minX
        let minY = rect.minY
        
        let maxX = rect.maxX
        let maxY = rect.maxY
        
        let centerY = maxY / 2
        
        let leftArcRadius = maxX * 0.01
        
        let leftArcPivot = leftArcRadius
        
        let rightArcRadius = maxY / 2
        
        path.move(to: CGPoint(x: minX, y: centerY))
        // top left arc
        path.addArc(withCenter: CGPoint(x: leftArcPivot, y: centerY),
                    radius: leftArcRadius,
                    startAngle: Double.pi,
                    endAngle: Double.pi * 3 / 2,
                    clockwise: true)
        // top line
        path.addLine(to: CGPoint(x: maxX - rightArcRadius, y: minY))
        // rigth arc
        path.addArc(withCenter: CGPoint(x: maxX - rightArcRadius, y: centerY),
                    radius: rightArcRadius,
                    startAngle: Double.pi * 3 / 2,
                    endAngle: Double.pi / 2,
                    clockwise: true)
        // bottom line
        path.addLine(to: CGPoint(x: leftArcPivot, y: centerY + leftArcPivot))
        // bottom left arc
        path.addArc(withCenter: CGPoint(x: leftArcPivot, y: centerY),
                    radius: leftArcRadius,
                    startAngle: Double.pi / 4,
                    endAngle: Double.pi,
                    clockwise: true)

        path.close()
        
        UIColor.black.setFill()
        
        UIColor.black.setStroke()
        
        path.fill()
        
        path.stroke()
        
        return path
    }
}
