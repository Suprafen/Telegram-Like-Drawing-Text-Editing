//
//  IPAvailableFontCollectionViewCell.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 20.11.22.
//

import Foundation
import UIKit

class IPAvailableFontCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "IPAvailableFontCollectionViewCellIdentifier"
    
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        label.textAlignment = .center
        label.backgroundColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("IT'S impossible to initialize")
    }
    
    func configure(withItem item: IPFont) {
        print("Configure called!")
        var attributes: [NSAttributedString.Key : Any] = [.font : item.font ?? UIFont(name: "HelveticaNeue-Medium", size: 20)!, .foregroundColor : UIColor.black]
//
        let attributedString = NSAttributedString(string: "Font Name", attributes: attributes)
        
        label.attributedText = attributedString
//        localTextStorage.setAttributedString(attributedString)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        label.attributedText = nil
//    }
}
