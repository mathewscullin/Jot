//
//  JotCollectionViewCell.swift
//  Jot
//
//  Created by Mathew Scullin on 1/31/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class JotCollectionViewCell: UICollectionViewCell {
    
    var jot : Jot? {
        didSet {
            
            if let fromID = jot?.fromID { 
                let ref = Database.database().reference().child("users").child(fromID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject] {
                        self.nameLabel.text = dictionary["name"] as? String
                        if dictionary["profileImageUrl"] as? String == "" {
                            self.profileImage.image = #imageLiteral(resourceName: "empty")
                        }
                        else {
                            if let profileImageURL = dictionary["profileImageUrl"] as? String {
                                self.profileImage.loadImageUsingCache(urlString: profileImageURL)
                            }
                        }
                    }
                }, withCancel: nil)
            }
            descriptor.text = jot?.descriptor
            
            if let realImageURL = jot?.images![0] as? String {
                firstImage.loadImageUsingCache(urlString: realImageURL)
            }
            
            if let seconds = jot?.timestamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
                timeLabel.text = dateFormatter.string(from: timeStampDate)
            }
        }
    }
    
    var profileImage : UIImageView!
    var nameLabel : UILabel!
    var descriptor : UILabel!
    var timeLabel : UILabel!
    var firstImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 20
        profileImage.contentMode = .scaleToFill
        contentView.addSubview(profileImage)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 22, weight: .medium)
        nameLabel.textColor = .gray
        nameLabel.textAlignment = .left
        contentView.addSubview(nameLabel)
        
        descriptor = UILabel()
        descriptor.translatesAutoresizingMaskIntoConstraints = false
        descriptor.font = .systemFont(ofSize: 16, weight: .regular)
        descriptor.textColor = .gray
        descriptor.textAlignment = .left
        contentView.addSubview(descriptor)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 16, weight: .light)
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .right
        contentView.addSubview(timeLabel)
        
        firstImage = UIImageView()
        firstImage.translatesAutoresizingMaskIntoConstraints = false
        firstImage.layer.masksToBounds = true
        firstImage.contentMode = .scaleAspectFill
        contentView.addSubview(firstImage) 
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImage.heightAnchor.constraint(equalToConstant: 40),
            profileImage.widthAnchor.constraint(equalToConstant: 40)
            ])
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10)
            ])
        NSLayoutConstraint.activate([
            descriptor.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            descriptor.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10)
            ])
        NSLayoutConstraint.activate([
            timeLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            ])
        NSLayoutConstraint.activate([
            firstImage.topAnchor.constraint(equalTo:descriptor.bottomAnchor, constant: 10),
            firstImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
