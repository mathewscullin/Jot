//
//  DetailJotViewController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/31/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class DetailJotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var jot : Jot!
    
    var images : [String]!
    
    var imagesCollectionView : UICollectionView!
    let padding : CGFloat = 10
    let imagesCellReuseIdentifier = "imagesCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: 0, right: padding)
        
        imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.backgroundColor = .clear
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.delegate = self
        imagesCollectionView.alwaysBounceVertical = true
        imagesCollectionView.register(StringToImageViewCell.self, forCellWithReuseIdentifier: imagesCellReuseIdentifier)
        view.addSubview(imagesCollectionView)
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    init(jot: Jot){
        super.init(nibName: nil, bundle: nil)
        if let fromID = jot.fromID {
            let ref = Database.database().reference().child("users").child(fromID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject] {
                    if let realName = dictionary["name"] as? String {
                        if(realName.last == "s") {
                            self.navigationItem.title = realName + "' Jot"
                        }
                        else{
                            self.navigationItem.title = realName + "'s Jot"
                        }
                    }
                }
            })
        }
        images = jot.images
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: imagesCellReuseIdentifier, for: indexPath) as! StringToImageViewCell
        let imageURL = images[indexPath.item]
        cell.layer.cornerRadius = 10
        cell.setNeedsUpdateConstraints()
        cell.configure(for: imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (imagesCollectionView.frame.width - padding * 2)
        return CGSize(width: length, height: length * (4/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(images[indexPath.item])
        let finalViewController = ImageViewController(for: images[indexPath.item])
        navigationController?.pushViewController(finalViewController, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
