//
//  ClassesCollectionViewCell.swift
//  Jot
//
//  Created by Mathew Scullin on 1/29/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit

class ClassesCollectionViewCell: UICollectionViewCell {
    
    var title : UILabel!
    
        override init(frame: CGRect) {
        super.init(frame: frame)
    
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.clear.cgColor
    
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 22, weight: .medium)
        title.textColor = .white
        title.textAlignment = .center
        contentView.addSubview(title)
    
    }
    
    override func updateConstraints() {
    super.updateConstraints()
    
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
    
    func configure(for name : String, number : Int) {
    title.text = name
        if number == 0 {
            contentView.setGradientSmall(colorOne: UIColor(red: 250/255, green: 161/255, blue: 42/255, alpha: 1.0), colorTwo: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 1.0))
        }
        if number == 1 {
            contentView.setGradientSmall(colorOne: UIColor(red: 0/255, green: 141/255, blue: 253/255, alpha: 1.0), colorTwo: UIColor(red: 170/255, green: 141/255, blue: 246/255, alpha: 1.0))
        }
        if number == 2 {
            contentView.setGradientSmall(colorOne: UIColor(red: 42/255, green: 255/255, blue: 152/255, alpha: 1.0), colorTwo: UIColor(red: 15/255, green: 190/255, blue: 216/255, alpha: 1.0))
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
