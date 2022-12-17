//
//  IPMapViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import UIKit
//MARK: IMPORTANT TASKS
// From the most to the least important

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
        let image = UIImage(named: "textLeft")

        let button = UIButton()
        button.setImage(image, for: .normal)
//        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(alignmentChangeBarButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let fillChangeButton: UIButton = {
        let image = UIImage(named: "default")
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(fillChangeBarButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let fontSizeSlider: IPSliderView = {
        
        let dimension = widthToDimensions(35)
        
        let slider = IPSliderView(frame: CGRect(x: 0, y: 0,
                                                width: dimension.width,
                                                height: dimension.height))
        
        slider.minimumValue = 30
        slider.value = 35
        slider.maximumValue = 70
        slider.isHidden = true
        slider.addTarget(nil, action: #selector(fontSizeSliderValueChanged(_:)), for: .valueChanged)

        return slider
        
    }()
    
    // MARK: - Stored properties
    
    var referenceTextViewCenterPoint: CGPoint = .init(x: 0, y: 0)
    
    var isEditingActive: Bool = false
    
    var maxTextViewFrameWidth: CGFloat = 0.0
    
    var previousAttributedText: NSAttributedString?
    
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
        
        setupStoredProperties()
        setupNotifications()
        addDarknerAndHelperButtons()
        setupViews()
    }
    
    func setupStoredProperties() {
        maxTextViewFrameWidth = UIScreen.main.bounds.width * 0.8
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
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
        
        collectionController.delegate = self
        
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
            collectionController.collectionView.leadingAnchor.constraint(equalTo: fillChangeButton.trailingAnchor, constant: 15),
            collectionController.collectionView.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -5),
            collectionController.collectionView.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -5)
        ])
    }
    
    func addDarknerAndHelperButtons() {
        self.view.addSubview(backgroundDarknerView)
        self.view.addSubview(doneButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(fontSizeSlider)
        
        // Center location for font size slider
        // default value
        fontSizeSlider.frame.origin = CGPoint(x: -fontSizeSlider.sFrame.maxX, y: (view.frame.minY + view.frame.maxY) / 2)
        // The value when pangesture is active
//        sender.center = CGPoint(x: 20, y: (view.frame.minY + view.frame.maxY) / 2)
        fontSizeSlider.transform = CGAffineTransform(rotationAngle: (.pi * 3) / 2)
        
        
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

// MARK: - Selectors
extension IPMapViewController {
    @objc func addNewTextView() {
        
        helperViewsHidden = false
        
        if fontSizeSlider.isHidden {
            fontSizeSlider.isHidden = false
        }
        
        let locaTextContainer: NSTextContainer = {
            let textContainer = NSTextContainer(size: .zero)
            
            textContainer.maximumNumberOfLines = 0
            
            return textContainer
        }()
        
        let localLayoutManager: IPNSLayoutManager = {
            let layoutManager = IPNSLayoutManager()
            
            return layoutManager
        }()
        
        let localTextStorage: IPNSTextStorage = {
            let attrStr = NSAttributedString(string: "text", attributes: [.font : UIFont(name: "Helvetica-Bold", size: 35)!])
            
            let textStorage = IPNSTextStorage()
            
            textStorage.replaceCharacters(in: NSRange(location: 0, length: 0), with: attrStr)
            
            return textStorage
        }()
              
        localLayoutManager.delegate = self
        
        localLayoutManager.addTextContainer(locaTextContainer)
        localTextStorage.addLayoutManager(localLayoutManager)
        
        let textView = IPTextView(frame: CGRect(x: 0, y: 0, width: maxTextViewFrameWidth,
                                                height: 150), textContainer: locaTextContainer)
       
        textView.inputAccessoryView = toolbar
        
        textView.backgroundColor = .blue.withAlphaComponent(0.3)
        
        textView.isScrollEnabled = false
        
        textView.spellCheckingType = .no
        
        textView.autocorrectionType = .no
        
        textView.delegate = self
        
        textView.isUserInteractionEnabled = true
        
        let pangestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(viewMoved(_:)))
        textView.addGestureRecognizer(pangestureRecognizer)
        
        view.addSubview(textView)
        
        textView.becomeFirstResponder() // This line helps me to invoke the keyboard when view appears on the screen.
        textView.center = view.center
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
        
        appStateController.changeFilledState()
        guard let attributedText = activeTextView.attributedText else {
            print("attributedText's fucked up!")
            return
        }
        
        var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        
        let imageName: String
        
        switch appStateController.filledAs {
            
        case .normal:
          
            imageName = "default"
            
            attributes.removeValue(forKey: .strokeColor)
            attributes.removeValue(forKey: .strokeWidth)
            
            attributes[.foregroundColor] = UIColor.black
            
        case .fill:
            
            imageName = "filled"
            
            attributes[.backgroundColor] = UIColor.black.withAlphaComponent(0)
            attributes[.foregroundColor] = UIColor.white
            
        case .fifthFill:
            
            imageName = "semi"
            
            attributes[.backgroundColor] = UIColor.orange.withAlphaComponent(0)
            attributes[.foregroundColor] = UIColor.white
            
        case .stroke:
            
            imageName = "stroke"

            attributes.removeValue(forKey: .backgroundColor)
            
            attributes[.foregroundColor] = UIColor.white
            attributes[.strokeColor] = UIColor.black
            attributes[.strokeWidth] = -3
            
        }

        let image = UIImage(named: imageName)
        
        fillChangeButton.setImage(image, for: .normal)

        let currentTextViewTextStorage = activeTextView.textStorage

        let attributedString = NSAttributedString(string: currentTextViewTextStorage.string, attributes: attributes)

        currentTextViewTextStorage.setAttributedString(attributedString)
        
        activeTextView.textAlignment = NSTextAlignment(rawValue: appStateController.alignment.rawValue) ?? .left
    }
    
    @objc func alignmentChangeBarButtonTapped() {
        guard let activeTextView = view.firstResponder as? IPTextView else { return }
        
        appStateController.changeAlignmentState()
        
        let imageName: String
        
        switch appStateController.alignment {
            
        case .left:
            
            imageName = "textLeft"
            
            activeTextView.textAlignment = .left
            
        case .center:
            
            imageName = "textCenter"
            
            activeTextView.textAlignment = .center
            
        case .right:
            
            imageName = "textRight"
            
            activeTextView.textAlignment = .right
            
        }
        
        let image = UIImage(named: imageName)

        alignmentChangeButton.setImage(image, for: .normal)
    }
    
    @objc func fontSizeSliderValueChanged(_ sender: UISlider) {
        // TODO: Fix this awfulness
        // Make a property instead and wake layout manager to do the job
        
        guard let textView = view.firstResponder as? IPTextView,
              let currentText = textView.text else {
            print("1st responder or current text has fucked up! - fontSizeSliderValueChanged")
            return
        }
        
        let currentTextStorage = textView.textStorage
        
        guard let range = currentText.range(of: currentText) else {
            print("Range's fucked up -availableFontsCollectionViewController")
            return
        }
        
        let convertedRange = NSRange(range, in: currentText)
        
        let attributes = currentTextStorage.attributes(at: 0, effectiveRange: nil)
        
        guard var font = attributes[.font] as? UIFont else {
            print("Getting font fucked up!")
            return
        }
        
        let step: Float = 1
        
        let roundedValue = round(sender.value * step) / step
        sender.value = roundedValue
        
        let fontSize = sender.value
        font = font.withSize(CGFloat(fontSize))
        
        currentTextStorage.addAttributes([.font : font], range: convertedRange)
        // Control text view's frame during font changings
        
        textView.frame.size = CGSize(width: 0, height: textView.frame.size.height)
        
        textView.sizeToFit()

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard !isEditingActive else { return }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let _ = keyboardRectangle.height // keyboard height
            
            let keyboardOrigin = keyboardRectangle.origin
            
            fontSizeSlider.center = CGPoint(x: 0, y: keyboardOrigin.y - fontSizeSlider.frame.minY / 2)
            
            guard let textView = view.firstResponder else { return }
            
            referenceTextViewCenterPoint = textView.center
            
            textView.center = view.center
            
            isEditingActive = true
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let center = fontSizeSlider.center
        
        fontSizeSlider.center = CGPoint(x: -fontSizeSlider.frame.maxY, y: center.y)
        // Maybe this code is redundant because there's
        // no way frame will be bigger than content size.
        guard let textView = view.firstResponder as? IPTextView else { return }
        
        let contentSize = textView.contentSize
        
        textView.frame.size = textView.sizeThatFits(contentSize)
        
        textView.textContainer.size = contentSize
        
        textView.sizeToFit()
        
        textView.center = referenceTextViewCenterPoint
        
        isEditingActive = false
    }
    
    
    @objc func viewMoved(_ sender: UIPanGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            senderView.center = CGPoint(x: senderView.center.x + translation.x,
                                        y: senderView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            
//        case .ended:
            // HEre goes the code that add bezier path that represent
            // kind of a border with two control points to change text's
            // translation(rotatition) state
            
        default:
            break
        }
        
    }
}

// MARK: - IPAvailableFontsCollectionViewControllerDelegate conformance
extension IPMapViewController: IPAvailableFontsCollectionViewControllerDelegate {
    
    func availableFontsCollectionViewController(chooseFont chosenFont: IPFont) {
        // TODO: Refactor this mess...
        guard let activeTextView = view.firstResponder as? IPTextView,
              let chosenFont = chosenFont.font,
              let currentText = activeTextView.text else {
            print("1st responder, chosen font or current text has fucked up! - availableFontsCollectionViewController")
            return
        }
        
        let currentTextStorage = activeTextView.textStorage
        
        guard let range = currentText.range(of: currentText) else {
            print("Range's fucked up -availableFontsCollectionViewController")
            return
        }
        
        let attr = currentTextStorage.attributes(at: 0, effectiveRange: nil)
        
        guard let currentFont = attr[.font] as? UIFont else { return }
        
        let convertedRange = NSRange(range, in: currentText)
        
        let fontToSet = chosenFont.withSize(currentFont.pointSize)
        
        currentTextStorage.addAttributes([.font : fontToSet], range: convertedRange)
    }
}

// MARK: - UITextViewDelegate conformance

extension IPMapViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.frame.size.width == maxTextViewFrameWidth {
            textView.frame.size = CGSize(width: maxTextViewFrameWidth, height: textView.frame.size.height)
        } else {
            textView.frame.size = CGSize(width: maxTextViewFrameWidth, height: textView.frame.size.height)
        }
        textView.sizeToFit()
        
        guard let currentText = textView.text,
              !currentText.isEmpty,
              let currentAttributedText = textView.attributedText else {
            previousAttributedText = textView.attributedText
            return
        }
        
        let attributes = currentAttributedText.attributes(at: 0, effectiveRange: nil)
        
        let currentTextStorage = textView.textStorage
        
        
        guard let range = currentText.range(of: currentText) else {
            print("Range's fucked up - textViewDidChange")
            return
        }
        
        let convertedRange = NSRange(range, in: currentText)
        
        currentTextStorage.setAttributes(attributes, range: convertedRange)
        
        previousAttributedText = textView.attributedText
    }
}

// MARK: - NSLayoutManagerDelegate

extension IPMapViewController: NSLayoutManagerDelegate {
    
//    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        return 10.0
//    }
//    
//    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        return 10.0
//    }
//    
}
