//
//  IPMapViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import UIKit
//MARK: IMPORTANT TASKS

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
    
    let toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        
        return view
    }()
    
    //MARK: - Text Editing Buttons.
    let alignmentChangeButton: UIButton = {
        let image = UIImage(systemName: "text.aligncenter")?.withRenderingMode(.alwaysTemplate).withTintColor(.black)

        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(alignmentChangeBarButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let fillChangeButton: UIButton = {
        let image = UIImage(systemName: "a.square")?.withRenderingMode(.alwaysTemplate).withTintColor(.black)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(fillChangeBarButtonTapped), for: .touchUpInside)
        
        return button
    }()
    // MARK: - Stored properties
    
    let collectionController = IPAvailableFontsCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    
    var helperViewsHidden: Bool = true {
        willSet(newValue) {
            
            doneButton.isHidden = newValue
            cancelButton.isHidden = newValue
            backgroundDarknerView.isHidden = newValue
            
        }
    }
    
    var appStateController = AppStateController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addDarknerAndHelperButtons()
        setupViews()
    }
    
    func setupViews() {
        setupToolbar()
        
        view.addSubview(addNewTextViewButton)
        
        NSLayoutConstraint.activate([
            addNewTextViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewTextViewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    func setupToolbar() {
        toolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        collectionController.collectionView!.translatesAutoresizingMaskIntoConstraints = false
        collectionController.view.backgroundColor = .orange
        
        self.addChild(collectionController)
        collectionController.didMove(toParent: self)

        toolbar.addSubview(alignmentChangeButton)
        toolbar.addSubview(fillChangeButton)
        toolbar.addSubview(collectionController.collectionView)
        

        NSLayoutConstraint.activate([
            
            alignmentChangeButton.topAnchor.constraint(equalTo: toolbar.topAnchor, constant: 5),
            alignmentChangeButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 5),
            alignmentChangeButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -5),
            
            fillChangeButton.topAnchor.constraint(equalTo: toolbar.topAnchor, constant: 5),
            fillChangeButton.leadingAnchor.constraint(equalTo: alignmentChangeButton.trailingAnchor, constant: 5),
            fillChangeButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -5),
            
            collectionController.collectionView.topAnchor.constraint(equalTo: toolbar.topAnchor, constant: 5),
            collectionController.collectionView.leadingAnchor.constraint(equalTo: fillChangeButton.trailingAnchor, constant: 90),
            collectionController.collectionView.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -5),
            collectionController.collectionView.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -5)
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
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
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
            let attrStr = NSAttributedString(string: "text", attributes: [.font : UIFont(name: "HelveticaNeue", size: 20)!])
            
            let mutAttrStr = NSMutableAttributedString(attributedString: attrStr)
            let textStorage = NSTextStorage(attributedString: mutAttrStr)
            
            return textStorage
        }()
              
        localLayoutManager.addTextContainer(locaTextContainer)
        localTextStorage.addLayoutManager(localLayoutManager)
        
        let textView = IPTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                  textContainer: locaTextContainer)
       
        textView.inputAccessoryView = toolbar
        
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1
        textView.autocorrectionType = .no
        // This line removes suggested words above the keyboard
        textView.spellCheckingType = .no
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
        //TODO: Keep in mind that this method can remove active text view ONLY if it is the first responder
        helperViewsHidden = true
        
        guard let firstResponder = view.firstResponder else { return }
        
        firstResponder.resignFirstResponder()
        
        guard let lastView = view.subviews.last else { return }
        
        lastView.removeFromSuperview()
    }
    
    @objc func fillChangeBarButtonTapped() {
        guard let activeTextView = view.firstResponder as? IPTextView else { return }
        
        var attributes: [NSAttributedString.Key : Any] = [.font : UIFont(name: "HelveticaNeue-Medium", size: 20)!]
        
        appStateController.changeFilledState()
        
        switch appStateController.filledAs {
            
        case .normal:
            
            break
            
        case .fill:
            
            attributes[.backgroundColor] = UIColor.black
            attributes[.foregroundColor] = UIColor.white
            
        case .fifthFill:
            
            attributes[.backgroundColor] = UIColor.black.withAlphaComponent(0.2)
            attributes[.foregroundColor] = UIColor.white
            
        case .stroke:
            
            attributes[.backgroundColor] = UIColor.clear
            attributes[.foregroundColor] = UIColor.white
            attributes[.strokeColor] = UIColor.black
            attributes[.strokeWidth] = 3
            
        }

        let currentTextViewTextStorage = activeTextView.textStorage
        
        let attributedString = NSAttributedString(string: currentTextViewTextStorage.string, attributes: attributes)
        
        currentTextViewTextStorage.setAttributedString(attributedString)
        
        activeTextView.textAlignment = NSTextAlignment(rawValue: appStateController.alignment.rawValue) ?? .left
    }
    
    @objc func alignmentChangeBarButtonTapped() {
        guard let activeTextView = view.firstResponder as? IPTextView else { return }
        
        appStateController.changeAlignmentState()
        
        switch appStateController.alignment {
            
        case .left:
            
            activeTextView.textAlignment = .left
            
        case .center:
            
            activeTextView.textAlignment = .center
            
        case .right:
            
            activeTextView.textAlignment = .right
            
        }
    }
}
