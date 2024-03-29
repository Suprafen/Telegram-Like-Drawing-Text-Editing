//
//  IPMapViewController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 1.11.22.
//

import UIKit

class IPMapViewController: UIViewController {
    
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
        button.accessibilityIdentifier = "addNewTextViewButton"
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.isHidden = true
        button.addTarget(nil, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "doneButton"

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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let blurView = UIVisualEffectView(effect: nil)
        
        blurView.effect = UIBlurEffect(style: .dark)
        
        blurView.frame = view.frame
        
        view.addSubview(blurView)
        
        return view
    }()
    
    //MARK: - Text Editing Buttons.
    let alignmentChangeButton: UIButton = {
        let image = UIImage(named: "textLeft")

        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(alignmentChangeBarButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "alignmentChangeButton"

        return button
    }()
    
    let fillChangeButton: UIButton = {
        let image = UIImage(named: "default")
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(fillChangeBarButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "fillStateChangeButton"
        
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
        
        slider.addTarget(nil, action: #selector(fontSizeSliderValueChanged(_:)), for: .valueChanged)
        slider.accessibilityIdentifier = "fontSizeSlider"

        return slider
        
    }()
    
    // MARK: - Stored properties
    
    var referenceTextViewCenterPoint: CGPoint = .init(x: 0, y: 0)
    
    var isEditingActive: Bool = false
    
    var maxTextViewFrameWidth: CGFloat = 0.0
    
    var previousAttributedText: NSAttributedString?
    
    let collectionController = IPAvailableFontsCollectionViewController(collectionViewLayout: UICollectionViewLayout())
    
    var filledAs: IPTextFillState = .defaultFill {
        willSet(newValue) {
            switch newValue {
            case .defaultFill:
                fillChangeButton.setImage(UIImage(named: "default"), for: .normal)
            case .filled:
                fillChangeButton.setImage(UIImage(named: "filled"), for: .normal)
                case .semi:
                    fillChangeButton.setImage(UIImage(named: "semi"), for: .normal)
            case .stroke:
                fillChangeButton.setImage(UIImage(named: "stroke"), for: .normal)
            }
        }
    }

        var alignedAs: IPTextAlignmentState = .left {
            willSet(newValue) {
                switch newValue {
                case .left:
                    alignmentChangeButton.setImage(UIImage(named: "textLeft"), for: .normal)
                case .center:
                    alignmentChangeButton.setImage(UIImage(named: "textCenter"), for: .normal)
                case .right:
                    alignmentChangeButton.setImage(UIImage(named: "textRight"), for: .normal)
                }
            }
        }

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

    func correctToolbarButtonsImages() {
        guard let textView = view.firstResponder as? IPTextView else { return }
        
        // Either could be moved to text view class and called as a function and we've got here a closure
        // or we could have a delegate method that would be called when the text view changes its state.
        switch textView.textFillState {
            case .defaultFill:
                fillChangeButton.setImage(UIImage(named: "default"), for: .normal)
            case .filled:
                fillChangeButton.setImage(UIImage(named: "filled"), for: .normal)
            case .semi:
                 fillChangeButton.setImage(UIImage(named: "semi"), for: .normal)
            case .stroke: 
                fillChangeButton.setImage(UIImage(named: "stroke"), for: .normal)
        }

        switch textView.textAlignmentState {
            case .left:
                alignmentChangeButton.setImage(UIImage(named: "textLeft"), for: .normal)
            case .center:
                alignmentChangeButton.setImage(UIImage(named: "textCenter"), for: .normal)
            case .right:
                alignmentChangeButton.setImage(UIImage(named: "textRight"), for: .normal)
        }
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
        
        collectionController.collectionView!.translatesAutoresizingMaskIntoConstraints = false
        collectionController.view.backgroundColor = .orange
        collectionController.collectionView.accessibilityIdentifier = "availableFontsCollectionView"
        
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
        
        fontSizeSlider.center = CGPoint(x: -fontSizeSlider.sFrame.maxY, y: fourthsOfTheScreenFromAbove)
        
        fontSizeSlider.transform = CGAffineTransform(rotationAngle: (.pi * 3) / 2)
        
        fontSizeSlider.delegate = self
        
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
            let attrStr = NSAttributedString(string: " ", attributes: [.font : UIFont(name: "Helvetica-Bold", size: 35)!])
            
            let textStorage = IPNSTextStorage()
            
            textStorage.replaceCharacters(in: NSRange(location: 0, length: 0), with: attrStr)
            
            return textStorage
        }()
              
        localLayoutManager.delegate = self
        
        localLayoutManager.addTextContainer(locaTextContainer)
        localTextStorage.addLayoutManager(localLayoutManager)
        
        let textView = IPTextView(frame: CGRect(x: 0, y: 0, width: 60,
                                                height: 50), textContainer: locaTextContainer)
        
        textView.isSelected = true
        
        textView.inputAccessoryView = toolbar
        
        textView.text = ""
        
        textView.contentMode = .redraw
        
        textView.backgroundColor = .clear
        
        textView.isScrollEnabled = false
        
        textView.spellCheckingType = .no
        
        textView.autocorrectionType = .no
        
        textView.delegate = self
        
        textView.ipDelegate = self
        
        textView.isUserInteractionEnabled = true
        
        let pangestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(viewMoved(_:)))
        textView.addGestureRecognizer(pangestureRecognizer)
        
        view.addSubview(textView)
        
        let _ = textView.becomeFirstResponder() // This line helps me to invoke the keyboard when view appears on the screen.
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
        guard let textView = view.firstResponder as? IPTextView else { return }
        
        appStateController.changeFilledState()
        guard let attributedText = textView.attributedText else {
            print("attributedText's fucked up!")
            return
        }
        
        var attributes = attributedText.attributes(at: 0, effectiveRange: nil)
        
        switch appStateController.filledAs {
            
        case .defaultFill:
          
            filledAs = .defaultFill
            textView.textFillState = .defaultFill

            attributes.removeValue(forKey: .strokeColor)
            attributes.removeValue(forKey: .strokeWidth)
            
            attributes[.foregroundColor] = UIColor.black
            
        case .filled:
            
            filledAs = .filled
            textView.textFillState = .filled

            attributes[.backgroundColor] = UIColor.black.withAlphaComponent(0)
            attributes[.foregroundColor] = UIColor.white
            
        case .semi:
            
            filledAs = .semi
            textView.textFillState = .semi
            
            attributes[.backgroundColor] = UIColor.orange.withAlphaComponent(0)
            attributes[.foregroundColor] = UIColor.white
            
        case .stroke:
            
            filledAs = .stroke
            textView.textFillState = .stroke

            attributes.removeValue(forKey: .backgroundColor)
            
            attributes[.foregroundColor] = UIColor.white
            attributes[.strokeColor] = UIColor.black
            attributes[.strokeWidth] = -3
            
        }

        let currentTextViewTextStorage = textView.textStorage

        let attributedString = NSAttributedString(string: currentTextViewTextStorage.string, attributes: attributes)

        currentTextViewTextStorage.setAttributedString(attributedString)
        
        textView.textAlignment = NSTextAlignment(rawValue: appStateController.alignment.rawValue) ?? .left
    }
    
    @objc func alignmentChangeBarButtonTapped() {
        guard let textView = view.firstResponder as? IPTextView else { return }
        
        appStateController.changeAlignmentState()
        
        switch appStateController.alignment {
            
        case .left:
    
            textView.textAlignmentState = .left
            alignedAs = .left

        case .center:
            
            textView.textAlignmentState = .center
            alignedAs = .center

        case .right:

            textView.textAlignmentState = .right
            alignedAs = .right

        }
    }
    
    @objc func fontSizeSliderValueChanged(_ sender: UISlider) {
        // TODO: Fix this awfulness
        // Make a property instead and wake layout manager to do the job
        guard let textView = view.firstResponder as? IPTextView,
              let currentText = textView.text else {
            print("1st responder or current text has fucked up! - fontSizeSliderValueChanged")
            return
        }
        // Current implementation cause text glitching
        // when slider value is get increased
        if (textView.frame.width > view.bounds.width * 0.8){
            
            textView.frame.size.height = textView.contentSize.height
            textView.frame.size.width = view.bounds.width * 0.8
            
        }else {
            //This line, well maybe not this exactly, but with help of which
            // Text is going to be shrinked horizontaly but layout properly vertically
            textView.frame.size = CGSize(width: maxTextViewFrameWidth, height: textView.frame.size.height)
            textView.sizeToFit()
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

    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard !isEditingActive else { return }
        
        correctToolbarButtonsImages()
        
        fontSizeSlider.center = CGPoint(x: 0, y: fourthsOfTheScreenFromAbove)
        
        guard let textView = view.firstResponder else { return }
        
        referenceTextViewCenterPoint = textView.center
        
        textView.center = view.center
        
        isEditingActive = true
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        fontSizeSlider.center = CGPoint(x: -(fontSizeSlider.bounds.maxY / 2), y: fourthsOfTheScreenFromAbove)
        
        guard let textView = view.firstResponder as? IPTextView else { return }
        
        let contentSize = textView.contentSize
        
        textView.frame.size = textView.sizeThatFits(contentSize)
        
        textView.textContainer.size = contentSize
        
        textView.sizeToFit()
        
        textView.isSelected = false
        
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
        
        textView.frame.size = CGSize(width: maxTextViewFrameWidth, height: textView.frame.size.height)
        
        textView.sizeToFit()
        
        textView.center = view.center
        
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

extension IPMapViewController: IPSliderDelegate {
    func touchesEnded() {
        UIView.animate(withDuration: 0.3) {
            self.fontSizeSlider.center = CGPoint(x: 0, y: fourthsOfTheScreenFromAbove)
        }
    }
    
    func touchesBegan() {
        UIView.animate(withDuration: 0.3) {
            self.fontSizeSlider.center = CGPoint(x: self.fontSizeSlider.sFrame.maxY - self.fontSizeSlider.sFrame.maxY * 0.2, y: fourthsOfTheScreenFromAbove)
        }
    }
}

// MARK: - BEZIER PATH FOR TEXTVIEW'S BORDER
extension UIBezierPath {
    
    func addLine(rtc: CGPoint, cornerRadius: CGFloat) {
        self.addLine(to: CGPoint(x: rtc.x - cornerRadius, y: rtc.y))
    }
    
    func addArc(rtc: CGPoint, cornerRadius: CGFloat) {
        self.addArc(withCenter: CGPoint(x: rtc.x - cornerRadius,
                                                  y: rtc.y + cornerRadius), radius: cornerRadius, startAngle: CGFloat(3 * Double.pi / 2), endAngle: 0, clockwise: true)
    }
    
    func addLine(rbc: CGPoint, cornerRadius: CGFloat) {
        self.addLine(to: CGPoint(x: rbc.x, y: rbc.y - cornerRadius))
    }
    
    func addArc(rbc: CGPoint, cornerRadius: CGFloat) {
            self.addArc(withCenter: CGPoint(x: rbc.x - cornerRadius,
                                                  y: rbc.y - cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)
    }
    
    func addLine(lbc: CGPoint, cornerRadius: CGFloat) {
        self.addLine(to: CGPoint(x: lbc.x + cornerRadius, y: lbc.y))
    }
    
    func addArc(lbc: CGPoint, cornerRadius: CGFloat) {
        self.addArc(withCenter: CGPoint(x: lbc.x + cornerRadius,
                                                  y: lbc.y - cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)
    }
    
    func addLine(ltc: CGPoint, cornerRadius: CGFloat) {
        self.addLine(to: CGPoint(x: ltc.x, y: ltc.y + cornerRadius))
    }
    
    func addArc(ltc: CGPoint, cornerRadius: CGFloat) {
        self.addArc(withCenter: CGPoint(x: ltc.x + cornerRadius,
                                                  y: ltc.y + cornerRadius), radius: cornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)
    }
}

extension IPMapViewController: IPTextViewDelegate {
    func presentControlPath(forTextView textView: IPTextView) {
        self.setupCALayer(forTextView: textView)
    }
    
    func removeControlPath() {
        view.layer.sublayers?.filter { $0 is CAShapeLayer }.forEach({ $0.removeFromSuperlayer() })
    }
}

extension IPMapViewController {
    func showBorderWithCircles(aroundTextView textView: IPTextView) {
        
        // self.drawCircles()
    }

    private func setupCALayer(forTextView textView: IPTextView) {
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = "borderLayer"
        let pth = drawBorder(aroundTextView: textView)
        borderLayer.path = pth.cgPath
        borderLayer.lineWidth = 2
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineDashPattern = [20, 10]
        view.layer.insertSublayer(borderLayer, at: 0)
        borderLayer.position = textView.frame.origin
        
    }
    
    private func drawBorder(aroundTextView textView: IPTextView) -> UIBezierPath {
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: textView.frame.width, height: textView.frame.height))
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        path.stroke()
        return path
    }
}
