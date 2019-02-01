//
//  StringToImageViewCell.swift
//  Jot
//
//  Created by Mathew Scullin on 1/31/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class StringToImageViewCell: UICollectionViewCell {
    
    var image : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        contentView.addSubview(image)
        
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
    }
    
    func configure(for imageURL: String) {
        image.loadImageUsingCache(urlString: imageURL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

