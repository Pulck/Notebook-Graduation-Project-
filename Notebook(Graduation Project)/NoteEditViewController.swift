//
//  NoteEditViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/31.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var accessoryView: CustomInputAccessoryView!
    
    var imageStore = ImageStore()
    var imageKeyMap = [NSTextAttachment : String]()
    var imageKeys = [String]()
    var context = AppDelegate.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.isEditable = false
        if !textView.text.isEmpty {
            tipsLabel.isHidden = true
        }
        
        textView.panGestureRecognizer.addTarget(self, action: #selector(panGestureAction(_:)))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.textView.addGestureRecognizer(doubleTapGesture)
        
        accessoryView.textView = textView
        textView.allowsEditingTextAttributes = true
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(observeKeyboardInfo(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            if sender.location(in: view).y > textView.frame.maxY && textView.isFirstResponder {
                textView.resignFirstResponder()
            }
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //let _ = try? context.save()
    }
    
    @IBOutlet weak var editableTipsImageView: UIImageView!
    let isShowKeyboardGesture: (_ gesture: UIGestureRecognizer) -> Bool = { $0 is UITapGestureRecognizer &&
        ($0 as! UITapGestureRecognizer).numberOfTapsRequired == 1 }
    @objc func doubleTap(_ sender: UIGestureRecognizer) {
        textView.isEditable = !textView.isEditable
        if textView.isEditable {
            textView.inputAccessoryView = accessoryView
            editableTipsImageView.image = #imageLiteral(resourceName: "Pencil")
            if let index = textView.gestureRecognizers?.index(where: isShowKeyboardGesture) {
                textView.gestureRecognizers![index].require(toFail: sender)
            }
        } else {
            textView.inputAccessoryView = nil
            editableTipsImageView.image = #imageLiteral(resourceName: "ReadIcon")
        }
    }
    
    @IBOutlet weak var keyboardInset: NSLayoutConstraint!
    @IBOutlet weak var toolbar: UIToolbar!
    @objc func observeKeyboardInfo(_ notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        
        let frame = info[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var toolbarInset = toolbar.bounds.height
        if frame.minY == view.bounds.height {
            toolbarInset = 0
        }
        
        textView.scrollRangeToVisible(textView.selectedRange)
        keyboardInset.constant = (view.bounds.height - frame.minY - toolbarInset)
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        })
       
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popoverPresentationController = segue.destination.popoverPresentationController {
            popoverPresentationController.delegate = self
            popoverPresentationController.presentedViewController.preferredContentSize = CGSize(width: 150, height: 170)
            popoverPresentationController.sourceRect = CGRect(x: 10, y: 10, width: 10, height: 10)
            
        }
    }
    
    @IBAction func test(_ sender: UIButton) {
        if let attribue = textView.typingAttributes[NSAttributedStringKey.font.rawValue],  let font = attribue as? UIFont{
            print("descriptor: \(font.fontDescriptor) selectedRange: \(textView.selectedRange)")
            textView.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = UIColor.red
        }
    }
    
    @IBOutlet var fontSettingView: FontSettingView! {
        didSet {
            fontSettingView.delegate = self
        }
    }
    
    @IBAction func showOrHideFontSettingView(_ sender: UIButton) {
        if textView.inputView == nil {
            textView.inputView = fontSettingView
        } else {
            textView.inputView = nil
        }
        if textView.isFirstResponder {
            textView.reloadInputViews()
        } else {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UIButton) {
        textView.inputView = nil
        textView.resignFirstResponder()
        showCamera(UIBarButtonItem())
    }
    
    @IBAction func showCamera(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func createMap(attributedString: NSAttributedString) {
        let range = NSRange(location: 0, length: attributedString.length)
        var index = 0
        imageKeyMap = [:]
        
        attributedString.enumerateAttribute(.attachment, in: range, options: []) { (result, range, stop) in
            if let attachment = result as? NSTextAttachment {
                imageKeyMap[attachment] = imageKeys[index]
                index += 1
            }
        }
    }
}

extension NoteEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        
        tipsLabel.isHidden = text.count == 0 ? false : true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let imageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageView") as! ImageViewController
        imageViewController.image = imageStore.image(forKey: imageKeyMap[textAttachment]!)
        show(imageViewController, sender: self)
        
        return true
    }
    
}

extension NoteEditViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
        ) -> UIModalPresentationStyle {
        
        if traitCollection.verticalSizeClass == .regular {
            return .none
        } else  {
            return .overFullScreen
        }
    }
}

extension NoteEditViewController: FontSettingDelegate {
    func fontSizeButtonClick(size: Int) {
        guard let _ = FontSize(rawValue: size) else {
            return
        }
        
        if let attribute = modifiedFontAttribute(in: textView.typingAttributes, size: size) {
            textView.typingAttributes = attribute
        }
    }
    
    func fontStyleButtonClick(_ sender: UIButton, style: String) {
        guard let fontStyle = FontStyle(rawValue: style) else {
            return
        }
        
        switch fontStyle {
        case .bold, .italic:
            if let attribute = modifiedFontAttribute(in: textView.typingAttributes, style: style) {
                sender.isSelected = !sender.isSelected
                textView.typingAttributes = attribute
            }
        case .underLine:
            var underlineStyle: NSNumber?
            if !sender.isSelected {
                sender.isSelected = true
                underlineStyle = NSUnderlineStyle.styleSingle.rawValue.number
            } else {
                sender.isSelected = false
                underlineStyle = nil
            }
            textView.typingAttributes[NSAttributedStringKey.underlineStyle.rawValue] = underlineStyle
        case .comment:
            var underlineStyle: NSNumber?
            if !sender.isSelected {
                sender.isSelected = true
                underlineStyle = NSUnderlineStyle.styleSingle.rawValue.number
            } else {
                sender.isSelected = false
                underlineStyle = nil
            }
            textView.typingAttributes[NSAttributedStringKey.strikethroughStyle.rawValue] = underlineStyle
        }
        
    }
    
    func modifiedFontAttribute(in attribute:[String : Any], style: String? = nil, size: Int? = nil) -> [String : Any]? {
        var attribute = attribute
        if let currentFontAttribute = attribute[NSAttributedStringKey.font.rawValue], let currentFont = currentFontAttribute as? UIFont {
            if let fontNameAttribute = currentFont.fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName.name], let fontName = fontNameAttribute as? String {
                var newFontAttribures = currentFont.fontDescriptor.fontAttributes
                if style != nil {
                    if !fontName.hasSuffix(style!) {
                        newFontAttribures[UIFontDescriptor.AttributeName.name] = "Helvetica-" + style!
                    } else {
                        newFontAttribures[UIFontDescriptor.AttributeName.name] = "Helvetica"
                    }
                }
                
                if size != nil {
                    newFontAttribures[UIFontDescriptor.AttributeName.size] = size!.number
                }
                
                let newFont = UIFont(descriptor: UIFontDescriptor(fontAttributes: newFontAttribures), size: 0.0)
                attribute[NSAttributedStringKey.font.rawValue] = newFont
                return attribute
            }
        }
        return nil
    }
}

extension NoteEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
       
        //compress image
        let scale = textView.bounds.width / image.size.width
        let originImageSize = image.size
        let size = CGSize(width: originImageSize.width * scale, height: originImageSize.height * scale)
        UIGraphicsBeginImageContext(size);
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        
        //attachement
        let attachement = NSTextAttachment()
        attachement.image = resultImage
        
        let currentImageKey = UUID().uuidString
        imageStore.setImage(image, forKey: currentImageKey)
        imageKeys.append(currentImageKey)
        imageKeyMap[attachement] = currentImageKey

        //insert image
        textView.textStorage.insert(NSAttributedString(attachment: attachement), at: textView.selectedRange.location)
        
        createMap(attributedString: textView.attributedText)
        dismiss(animated: true, completion: nil)
    }
}

extension Int {
    var number: NSNumber {
        return NSNumber(value: self)
    }
}
