//
//  PlainTextCell.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/23.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class PlainTextCell: UITableViewCell {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteDateLabel: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var imageArea: UIStackView!
    @IBOutlet weak var horizonStack: UIStackView!
    
    private lazy var verticalImageViews: [(view: UIImageView, height: NSLayoutConstraint)] = {
        var views =  [(view: UIImageView, height: NSLayoutConstraint)]()
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
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
    
    private lazy var horizonImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.isHidden = true
        horizonStack.addArrangedSubview(view)
        return view
    }()
    
    var noteImages = [UIImage]() {
        didSet {
            updateImage()
            updateImageAppear()
        }
    }
    var appearMode = ImageAppearMode.normal {
        didSet {
            updateImageAppear()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateImage() {
        for (index, image) in noteImages.enumerated() {
            let imageView = verticalImageViews[index]
            imageView.view.image = image
            imageView.view.isHidden = false
            if index == 0 {
                horizonImageView.image = image
            }
        }
    }
    
    func updateImageAppear() {
        switch appearMode {
        case .large:
            horizonImageView.isHidden = true
            for view in verticalImageViews {
                view.height.isActive = false
                if view.view.image != nil {
                    view.view.isHidden = false
                }
            }
            noteTextLabel.numberOfLines = 5
        case .normal:
            for view in verticalImageViews {
                view.height.isActive = true
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

}

enum ImageAppearMode {
    case normal
    case large
    case small
}
