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
    
    var addNewTextViewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(nil, action: #selector(addNewTextView), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.isHidden = true
        button.addTarget(nil, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.isHidden = true
        button.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: Background Darkner
    let backgroundDarknerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isHidden = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    var helperViewsHidden: Bool = true {
        willSet(newValue) {
            doneButton.isHidden = newValue
            cancelButton.isHidden = newValue
            backgroundDarknerView.isHidden = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addDarknerAndHelperButtons()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(addNewTextViewButton)
        
        NSLayoutConstraint.activate([
            addNewTextViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewTextViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    func addDarknerAndHelperButtons() {
        self.view.addSubview(backgroundDarknerView)
        self.view.addSubview(doneButton)
        self.view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            backgroundDarknerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundDarknerView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundDarknerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundDarknerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
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
        helperViewsHidden = false
        
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
        textView.backgroundColor = .clear
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
    
    @objc func doneButtonTapped() {
        helperViewsHidden = true
        
        guard let firstResponder = view.firstResponder else { return }
        
        firstResponder.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        helperViewsHidden = true
        
        guard let firstResponder = view.firstResponder else { return }
        
        firstResponder.resignFirstResponder()
        
        guard let lastView = view.subviews.last else { return }
        
        lastView.removeFromSuperview()
    }
}
