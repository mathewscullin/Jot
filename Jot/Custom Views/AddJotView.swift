//
//  AddJotView.swift
//  Jot
//
//  Created by Mathew Scullin on 1/30/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class AddJotView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    weak var delegate : stopDelegate?
    
    var classTitle : String!
    var descriptionLecture : UITextField!
    
    var images : UICollectionView!
    var imagesArray : [UIImage]! = []
    let padding : CGFloat = 10
    let imagesCellReuseIdentifier = "imagesCellReuseIdentifier"
    
    var plus : UIButton!
    var add : UIButton!
    var cancel : UIButton!
    
    var imageURLS : [String]! = []
    
    init(frame: CGRect, title: String) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        classTitle = title
        
        descriptionLecture = UITextField()
        descriptionLecture.translatesAutoresizingMaskIntoConstraints = false
        descriptionLecture.placeholder = "Enter lecture description."
        descriptionLecture.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        descriptionLecture.layer.cornerRadius = 10
        descriptionLecture.font =  .systemFont(ofSize: 16, weight: .regular)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.descriptionLecture.frame.height))
        descriptionLecture.leftView = paddingView
        descriptionLecture.leftViewMode = UITextField.ViewMode.always
        self.addSubview(descriptionLecture)
        NSLayoutConstraint.activate([
            descriptionLecture.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            descriptionLecture.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLecture.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            descriptionLecture.heightAnchor.constraint(equalToConstant: 30)
            ])
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        self.addGestureRecognizer(tapToDismiss)
        
        plus = UIButton()
        plus.translatesAutoresizingMaskIntoConstraints = false
        plus.setImage(#imageLiteral(resourceName: "icons8-screenshot-30"), for: .normal)
        plus.clipsToBounds = true
        plus.layer.cornerRadius = 5
        plus.setTitleColor(.black, for: .normal)
        plus.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        plus.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.addSubview(plus)
        NSLayoutConstraint.activate([
            plus.leadingAnchor.constraint(equalTo: descriptionLecture.trailingAnchor, constant: 10),
            plus.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
            ])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        images = UICollectionView(frame: .zero, collectionViewLayout: layout)
        images.translatesAutoresizingMaskIntoConstraints = false
        images.backgroundColor = .white
        self.images.dataSource = self
        self.images.delegate = self
        images.alwaysBounceVertical = true
        images.register(ImageCell.self, forCellWithReuseIdentifier: imagesCellReuseIdentifier)
        self.addSubview(images)
        
        add = UIButton()
        add.translatesAutoresizingMaskIntoConstraints = false
        add.setTitle("Add", for: .normal)
        add.backgroundColor = UIColor(red: 80/255, green: 225/255, blue: 100/255, alpha: 1.0)
        add.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        add.tintColor = .white
        add.layer.cornerRadius = 5
        add.titleLabel?.textAlignment = .center
        add.clipsToBounds = true
        add.addTarget(self, action: #selector(handleJot), for: .touchUpInside)
        self.addSubview(add)
        NSLayoutConstraint.activate([
            add.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 5),
            add.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            add.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
        
        cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.backgroundColor = .lightGray
        cancel.setTitle("Cancel", for: .normal)
        cancel.titleLabel?.textAlignment = .center
        cancel.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cancel.layer.cornerRadius = 5
        cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        self.addSubview(cancel)
        NSLayoutConstraint.activate([
            cancel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -5),
            cancel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            cancel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            images.topAnchor.constraint(equalTo: descriptionLecture.bottomAnchor, constant: 10),
            images.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            images.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            images.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -10)
            ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = images.dequeueReusableCell(withReuseIdentifier: imagesCellReuseIdentifier, for: indexPath) as! ImageCell
        let image = imagesArray[indexPath.item]
        
        cell.configure(for: image)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (images.frame.width - padding * 2)
        return CGSize(width: length, height: length * (4/3))
    }
    
    @objc func addImage() {
        self.delegate?.present()
    }
    
    func addImageCollection(image: UIImage?) {
        if let selectedImage = image {
            imagesArray.append(selectedImage)
        }
        images.reloadData()
    }
    
    @objc func handleJot() {
        if imagesArray.count == 0 {
            self.delegate?.handleCase(bool: true)
            return
        }
        if descriptionLecture.text == "" {
            self.delegate?.handleCase(bool: false)
            return
        }
        setUpJot()
        self.delegate?.add() 
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    func setUpJot() {
        let imageName = NSUUID().uuidString
        let ref = Database.database().reference().child("jots")
        let childRef = ref.childByAutoId()
        for picture in imagesArray {
            let storageRef = Storage.storage().reference().child("jotImages").child("\(imageName).jpeg")
            if let uploadData = picture.jpegData(compressionQuality: 0.2) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    storageRef.downloadURL(completion: { (downloadUrl, error) in
                        guard let url = downloadUrl?.absoluteString else {return}
                        self.imageURLS.append(url)
                        let fromID = Auth.auth().currentUser?.uid
                        let className = self.classTitle
                        let descriptor = self.descriptionLecture.text
                        let URLS = self.imageURLS
                        let timestamp = Int(NSDate().timeIntervalSince1970)
                        var values = ["className" : className, "fromID" : fromID, "descriptor" : descriptor, "timestamp" : timestamp, "images" : URLS] as [String : Any]
                        /* Reason for updating multiple times is because Xcode would skip the downloading URL code section and add nil array of URL strings first then add the URL's after */
                        childRef.updateChildValues(values)
                        
                    })
                })
            }
        }
    }
    
     @objc func handleCancel() {
        self.delegate?.cancel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



