//
//  ViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import UIKit

class ViewController: UIViewController {
    
    //TODO: Maybe put that stuff to the separate class
    
    var textContainer: NSTextContainer = {
        let textContainer = NSTextContainer(size: .zero)
        
        textContainer.maximumNumberOfLines = 0
        
        return textContainer
    }()
    
    var layoutManager: NSLayoutManager = {
        let layoutManager = NSLayoutManager()
        
        return layoutManager
    }()
    
    var textStorage: NSTextStorage = {
        let attrStr = NSAttributedString(string: "Text here", attributes: [.backgroundColor : UIColor.systemRed])
        
        var mutAttrStr = NSMutableAttributedString(attributedString: attrStr)
        let textStorage = NSTextStorage(attributedString: mutAttrStr)
        
        return textStorage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        
        setupTextViews()
    }
     // Click on the button
    func setupTextViews() {
        // add layout container, manager and storage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        
        // initialize textview
        let customTextView = IPTextView(frame: CGRect(x: 50, y: 50, width: 300, height: 300), textContainer: textContainer)
        // setup contstraints
        
        view.addSubview(customTextView)
        
        view.center = customTextView.center
    }

}

