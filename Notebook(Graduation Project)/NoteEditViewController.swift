//
//  NoteEditViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/31.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class NoteEditViewController: UIViewController {
    static let maxTitleLen = 20
    static let maxPreviewTextLen = 60
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var accessoryView: CustomInputAccessoryView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notebookButton: UIButton!
    
    var imageStore = ImageStore.shared
    var imageKeyMap = [NSTextAttachment : String]()
    var imageKeys = [String]()
    var context = AppDelegate.viewContext
    var initialEditableState = false
    
    var noteData: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteDataInit()
        
        textView.delegate = self
        textView.isEditable = initialEditableState
        if initialEditableState == true {
            editableTipsImageView.image = #imageLiteral(resourceName: "Pencil")
        } else {
            editableTipsImageView.image = #imageLiteral(resourceName: "ReadIcon")
        }
        
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
    
    func noteDataInit() {
        if noteData == nil {
            create()
        } else {
            titleField.text = noteData.title
            if let content = noteData.content {
                let attributedText = try! NSAttributedString(data: content, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
                textView.attributedText = attributedText
                
                if let needKeys = noteData.imageKeys {
                    imageKeys = needKeys as! [String]
                    createMap(attributedString: attributedText)
                }
            }
        }
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
    
    deinit {
        save()
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    
    func save() {
        guard let text = titleField.text, let content = textView.attributedText else {
            return
        }
        
        var title: String
        let textContent = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        
        if textContent.isEmpty {
            title = String(textView.text.prefix(NoteEditViewController.maxTitleLen))
        } else {
            title = textContent
        }
        
        do {
            noteData.title = title
            noteData.modifyDate = Date()
            noteData.preview = String(textView.text.prefix(NoteEditViewController.maxPreviewTextLen))
            noteData.imageKeys = imageKeys as NSObject
            
            let range = NSRange(location: 0, length: content.length)
            let data = try content.data(from: range, documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.rtfd])
            noteData.content = data
            
            try context.save()
        } catch {
            fatalError("save failure: \(error)")
        }
        
    }
    
    func create() {
        noteData = Note(context: context)
        noteData.createdDate = Date()
        noteData.id = UUID().uuidString
        let navc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Select Notebook") as! UINavigationController
        let selectView = navc.topViewController! as! SelectNotebookViewController
        selectView.shouleHideCancelButton = true
        selectView.noteData = noteData
        present(navc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let notebookName = noteData.notebook?.name {
            notebookButton.setTitle(notebookName, for: .normal)
        }
    }
    
    
    @IBOutlet weak var editableTipsImageView: UIImageView!
    let isShowKeyboardGesture: (_ gesture: UIGestureRecognizer) -> Bool = { $0 is UITapGestureRecognizer &&
        ($0 as! UITapGestureRecognizer).numberOfTapsRequired == 1 }
    @objc func doubleTap(_ sender: UIGestureRecognizer) {
        textView.inputView = nil
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
        if segue.identifier == "Select Notebook" {
            let nvc = segue.destination as! UINavigationController
            let selectView = nvc.topViewController as! SelectNotebookViewController
            selectView.noteData = noteData
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
    
    @IBAction func insertAttachemntAction(_ sender: UIButton) {
        textView.inputView = nil
        textView.resignFirstResponder()
        
        let actionSheet = UIAlertController(title: NSLocalizedString("Select", comment: "选择输入方式"), message: "Select input", preferredStyle: .actionSheet)
        
        let selectCameraAction = UIAlertAction(title:  NSLocalizedString("Camera", comment: "照相机"), style: .default) {
            [weak self] (action) in
            self?.showCamera()
        }
        actionSheet.addAction(selectCameraAction)

        let selectPhotoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: "相册"), style: .default) {
            [weak self] (action) in
            self?.showPhotoLibrary()
        }
        actionSheet.addAction(selectPhotoLibraryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        showCamera()
    }
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func backAndSave() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backAndDelete() {
        noteData.notebook?.count -= 1
        context.delete(noteData)
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Text View Delegate
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let attributeText = textView.textStorage.attributedSubstring(from: range)
        if attributeText.length > 0 {
            let attributes = attributeText.attributes(at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: attributeText.length))
            if let attachement = attributes[.attachment] as? NSTextAttachment {
                let key = imageKeyMap[attachement]!
                imageKeyMap[attachement] = nil
                let index = imageKeys.index(of: key)!
                imageKeys.remove(at: index)
                imageStore.deleteImage(forKey: key)
            }
        }
        return true
    }
    
}

//MARK: - Font Setting View Delegate
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
    
    func fontColorButtonClick(color: UIColor) {
        textView.typingAttributes[NSAttributedStringKey.foregroundColor.rawValue] = color
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

//MARK: - Image Picker Extension
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
        UIGraphicsEndImageContext()
        
        //attachement
        let attachement = NSTextAttachment()
        attachement.image = resultImage
        
        let currentImageKey = UUID().uuidString
        imageStore.setImage(image, forKey: currentImageKey)
        imageKeys.append(currentImageKey)
        imageKeyMap[attachement] = currentImageKey

        //insert image
        textView.textStorage.insert(NSAttributedString(attachment: attachement), at: textView.selectedRange.location)
        tipsLabel.isHidden = true
        
        dismiss(animated: true, completion: nil)
    }
}

extension Int {
    var number: NSNumber {
        return NSNumber(value: self)
    }
}
