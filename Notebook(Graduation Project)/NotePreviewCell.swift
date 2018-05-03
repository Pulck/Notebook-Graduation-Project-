//
//  PlainTextCell.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/23.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

///笔记内容预览Cell
class NotePreviewCell: UITableViewCell {

    var note: Note! {
        didSet {
            updateCell()
        }
    }
    let imageStore = ImageStore.shared
    
    ///笔记标题
    @IBOutlet weak var noteTitleLabel: UILabel!
    ///笔记文本内容
    @IBOutlet weak var noteTextLabel: UILabel!
    ///笔记更新时间
    @IBOutlet weak var noteDateLabel: UILabel!
    ///外层包装视图，方便修改显示效果
    @IBOutlet weak var content: UIView!
    ///底部图片显示区域
    @IBOutlet weak var imageArea: UIStackView!
    ///横向显示图片时用来规范图片显示的位置
    @IBOutlet weak var horizonStack: UIStackView!
    
    ///图片在底部显示时用到的imageViews数组。数组中的元素是一个imageView与height约束组成的二元组
    private lazy var verticalImageViews: [(view: UIImageView, height: NSLayoutConstraint)] = {
        var views =  [(view: UIImageView, height: NSLayoutConstraint)]()
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            //利用约束的优先级对图片的高进行动态约束，保存优先级为require的normal显示模式的约束，激活或取消该约束来动态改变图片的高度
            let height = imageView.heightAnchor.constraint(equalToConstant: 150)
            height.priority = .required
            height.isActive = true
            let bigHeight = imageView.heightAnchor.constraint(equalToConstant: 200)
            bigHeight.priority = .defaultHigh
            bigHeight.isActive = true
            imageView.isHidden = true
            imageArea.addArrangedSubview(imageView)
            views.append((imageView, height))
        }
        return views
    }()
    
    ///图片水平显示时用到的imageView
    private lazy var horizonImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.isHidden = true
        horizonStack.addArrangedSubview(view)
        return view
    }()
    
    //TODO：当加入core data后需要更改其工作方式
    var noteImages = [UIImage]() {
        didSet {
            updateImage()
        }
    }
    
    ///指示当前的显示模式
    var appearModeIndicator: ImageAppearModeIndicator! {
        didSet {
            updateImageAppear()
        }
    }
    
    //覆盖该方法增加圆角效果
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 3
    }
    
    //与noteImages配合使用，需要在core data引入后修改
    func updateImage() {
        for (index, image) in noteImages.enumerated() {
            let imageView = verticalImageViews[index]
            imageView.view.image = image
            imageView.view.isHidden = false
            if index == 0 {
                horizonImageView.image = image
            }
        }
        updateImageAppear()
    }
    
    //用于清空所有数据
    func clearData() {
        for imageView in verticalImageViews {
            imageView.view.image = nil
            imageView.view.isHidden = true
        }
        horizonImageView.image = nil
        horizonImageView.isHidden = true
        
        noteDateLabel.text = "Date"
        noteTitleLabel.text = "Title"
        noteTextLabel.text = "text"
    }
    
    //用于在显示模式发生变化时更新显示
    func updateImageAppear() {
        guard appearModeIndicator != nil else {
            return
        }
        
        switch appearModeIndicator.appearMode {
        case .large:
            horizonImageView.isHidden = true
            for view in verticalImageViews {
                //调整图片视图高度为200
                view.height.isActive = false
                view.view.isHidden = view.view.image == nil ? true : false
            }
            noteTextLabel.numberOfLines = 5
        case .normal:
            horizonImageView.isHidden = true
            for view in verticalImageViews {
                //调整图片视图高度为150
                view.height.isActive = true
                view.view.isHidden = view.view.image == nil ? true : false
            }
            noteTextLabel.numberOfLines = 4
        case .small:
            for imageView in verticalImageViews {
                imageView.view.isHidden = true
            }
            horizonImageView.isHidden = false
            noteTextLabel.numberOfLines = 3
            break
        }
    }
    
    func updateCell() {
        clearData()
        
        guard let data = note else {
            return
        }
        
        if let date = data.createdDate {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            noteDateLabel.text = dateFormatter.string(from: date)
        } else {
            noteDateLabel.text = nil
        }
        
        noteTitleLabel.text = data.title
        noteTextLabel.text = data.preview
        
        let imageKeysData = data.imageKeys
        if let imageKeys = imageKeysData as? [String], imageKeys.count != 0 {
            noteImages = [#imageLiteral(resourceName: "ImagePlaceHolder")]
            
            let queue = DispatchQueue.global(qos: .userInitiated)
            queue.async {
                [weak self] in
                var images = [UIImage]()
                var count = 0
                for key in imageKeys {
                    if let image = self?.imageStore.image(forKey: key) {
                        let data = UIImageJPEGRepresentation(image, 0.5)!
                        images.append(UIImage(data: data)!)
                        count += 1
                    }
                    
                    if count == 3 {
                        break
                    }
                }
                DispatchQueue.main.async {
                    if data.id == self?.note.id {
                        self?.noteImages = images
                    }
                    
                }
            }
        } else {
            noteImages = []
        }
    }
}

///将具有值语义的枚举类型包装到类中，使所有cell的该属性具有引用语义，实现同步修改所有cell的显示模式
class ImageAppearModeIndicator {
    var appearMode = ImageAppearMode.normal
}

///图片视图的显示方式及大小，同样影响可显示的文字行数
enum ImageAppearMode {
    case normal
    case large
    case small
}
