//
//  IPMapViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import UIKit

class IPMapViewController: UIViewController {
    
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
    
    var customTextView: IPTextView?
    
    var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(nil, action: #selector(addNewTextView), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var addCALayerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setImage(UIImage(systemName: "plus")?.withTintColor(.systemOrange), for: .normal)
        button.addTarget(nil, action: #selector(addCALayer), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var removeCALayerButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setImage(UIImage(systemName: "minus")?.withTintColor(.systemOrange), for: .normal)
        button.addTarget(nil, action: #selector(removeCALayer), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTextViews()
        setupConstraints()
    }
     // Click on the button
    func setupTextViews() {
        
        view.addSubview(addButton)
        view.addSubview(addCALayerButton)
        view.addSubview(removeCALayerButton)
        // add layout container, manager and storage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // initialize textview
        customTextView = IPTextView(frame: CGRect(x: 50, y: 50, width: 300, height: 200), textContainer: textContainer)
        
        
        
        guard let customTextView = customTextView else { return }
        
        customTextView.layer.borderWidth = 1
        
        view.addSubview(customTextView)
        view.center = customTextView.center
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            addCALayerButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 30),
            addCALayerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            
            removeCALayerButton.leadingAnchor.constraint(equalTo: addCALayerButton.leadingAnchor, constant: 30),
            removeCALayerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

// MARK: - UITextViewDelegate methods
extension IPMapViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        
        guard let firstResponder = view.firstResponder else { return }
        
        let point = touch.location(in: view)

        if !firstResponder.bounds.contains(point) {
            firstResponder.resignFirstResponder()
            firstResponder.endEditing(true)
        }
    }
}

//MARK: - Selectors
extension IPMapViewController {
    @objc func addNewTextView() {
        // TODO: First version. Should change
        // here, somehow, I need to deal with text container, layuot manager and text storage
        let locaTextContainer: NSTextContainer = {
            let textContainer = NSTextContainer(size: .zero)
            
            textContainer.maximumNumberOfLines = 0
            
            return textContainer
        }()
        
        let localLayoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            
            return layoutManager
        }()
        
        let localTextStorage: NSTextStorage = {
            let attrStr = NSAttributedString(string: "Text here", attributes: [.font : UIFont.boldSystemFont(ofSize: 15)])
            
            let mutAttrStr = NSMutableAttributedString(attributedString: attrStr)
            let textStorage = NSTextStorage(attributedString: mutAttrStr)
            
            return textStorage
        }()
              
        localLayoutManager.addTextContainer(locaTextContainer)
        localTextStorage.addLayoutManager(localLayoutManager)
        
        let textView = IPTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                  textContainer: locaTextContainer)
        textView.layer.borderWidth = 1
        
        view.addSubview(textView)
        textView.becomeFirstResponder() // This line helps me to invoke the keyboard when view appears on the screen.
        textView.center = view.center
    }
    
    @objc func addCALayer() {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.withAlphaComponent(0.7).cgColor
        layer.frame = view.frame
        
        
        view.layer.addSublayer(layer)
    }

    
    @objc func removeCALayer() {
        if let layers = view.layer.sublayers {
            print("Layers: \(layers)")
        }
//        view.layer.sublayers?.removeLast()
    }
}
