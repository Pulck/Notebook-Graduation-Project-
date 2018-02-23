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
    
    var noteImages = [UIImage]() {
        didSet {
            addImage()
        }
    }
    var appearMode = ImageAppearMode.normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.layer.cornerRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addImage() {
        addLoop: for (index, image) in noteImages.enumerated() {
            guard index < 3 else {
                break
            }
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            var height = imageView.heightAnchor.constraint(equalToConstant: 150)
            
            switch appearMode {
            case .normal:
                break
            case .large:
                height = imageView.heightAnchor.constraint(equalToConstant: 200)
            case .small:
                height.isActive = true
                horizonStack.addArrangedSubview(imageView)
                break addLoop

            }
            height.isActive = true
            imageArea.addArrangedSubview(imageView)
        }
    }

}

enum ImageAppearMode {
    case normal
    case large
    case small
}
