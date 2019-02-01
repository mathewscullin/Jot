//
//  ProfileController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var line : UIView!
    
    var circle : UIView!
    var profilePic : UIImageView!
    
    var nameTag : UILabel!
    var name : UILabel!
    var usernameTag: UILabel!
    var username : UILabel!
    var emailTag : UILabel!
    var email : UILabel!
    
    var empty : UILabel!
    var search : UIImageView!
    
    var classes : UICollectionView!
    var classesArray : [String]! = []
    let padding : CGFloat = 10
    let classesCellReuseIdentifier = "classesCellReuseIdentifier"
    
    var colorNumber : Int!
    
    var logout : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
        circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.setGradientSmall(colorOne: UIColor(red: 250/255, green: 161/255, blue: 42/255, alpha: 1.0), colorTwo: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 1.0))
        circle.layer.cornerRadius = 65
        circle.layer.masksToBounds = true
        view.addSubview(circle)
        
        profilePic = UIImageView()
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.clipsToBounds = true
        profilePic.contentMode = .scaleAspectFill
        profilePic.layer.cornerRadius = 60
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilePicture)))
        profilePic.isUserInteractionEnabled = true
        view.addSubview(profilePic)
        
        usernameTag = UILabel()
        usernameTag.text = "username"
        usernameTag.translatesAutoresizingMaskIntoConstraints = false
        usernameTag.font = .systemFont(ofSize: 18, weight: .light)
        usernameTag.textColor = .darkGray
        usernameTag.textAlignment = .right
        view.addSubview(usernameTag)
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = .systemFont(ofSize: 22, weight: .medium)
        username.textColor = .darkGray
        username.textAlignment = .left
        view.addSubview(username)
        
        line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .darkGray
        view.addSubview(line)
        
        nameTag = UILabel()
        nameTag.text = "name"
        nameTag.translatesAutoresizingMaskIntoConstraints = false
        nameTag.font = .systemFont(ofSize: 18, weight: .light)
        nameTag.textColor = .darkGray
        nameTag.textAlignment = .right
        view.addSubview(nameTag)
        
        name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 18, weight: .regular)
        name.textColor = .darkGray
        name.textAlignment = .left
        view.addSubview(name)
        
        emailTag = UILabel()
        emailTag.text = "email"
        emailTag.translatesAutoresizingMaskIntoConstraints = false
        emailTag.font = .systemFont(ofSize: 18, weight: .light)
        emailTag.textColor = .darkGray
        emailTag.textAlignment = .right
        view.addSubview(emailTag)
        
        email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.font = .systemFont(ofSize: 18, weight: .regular)
        email.textColor = .darkGray
        email.textAlignment = .left
        view.addSubview(email)
        
        empty = UILabel()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.textColor = UIColor(red:0.65, green:0.65, blue:0.65, alpha:1.0)
        empty.font = .systemFont(ofSize: 16, weight: .regular)
        empty.text = "You have no classes! Add some in"
        empty.isHidden = true
        empty.alpha = 0.0
        empty.textAlignment = .center
        
        search = UIImageView()
        search.image = #imageLiteral(resourceName: "icons8-search-32")
        search.translatesAutoresizingMaskIntoConstraints = false
        search.contentMode = .scaleAspectFit
        if classesArray == [] {
            search.isHidden = false
            search.alpha = 1.0
            empty.isHidden = true
            empty.alpha = 1.0
        }
        else {
            empty.isHidden = true
            empty.alpha = 0.0
            search.isHidden = true
            search.alpha = 0.0
        }
        view.addSubview(empty)
        view.addSubview(search)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        classes = UICollectionView(frame: .zero, collectionViewLayout: layout)
        classes.translatesAutoresizingMaskIntoConstraints = false
        classes.backgroundColor = .white
        self.classes.dataSource = self
        self.classes.delegate = self
        classes.alwaysBounceVertical = true
        classes.register(DepartmentCollectionViewCell.self, forCellWithReuseIdentifier: classesCellReuseIdentifier)
        view.addSubview(classes)
        

        logout = UIButton()
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setGradientSmall(colorOne: UIColor(red: 250/255, green: 161/255, blue: 42/255, alpha: 1.0), colorTwo: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 1.0))
        logout.setTitle("Logout", for: .normal)
        logout.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        logout.titleLabel?.textAlignment = .center
        logout.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        logout.layer.borderWidth = 1
        logout.layer.borderColor = UIColor.white.cgColor
        logout.layer.cornerRadius = 25
        logout.layer.masksToBounds = true
        view.addSubview(logout)
        
        setUpConstraints()
        setUpProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setUpProfile() {
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                if dictionary["profileImageUrl"] as? String == "" {
                    self.profilePic.image = #imageLiteral(resourceName: "empty")
                }
                else {
                    if let profileImageURL = dictionary["profileImageUrl"] as? String {
                        self.profilePic.loadImageUsingCache(urlString: profileImageURL)
                    }
                }
                self.name.text = dictionary["name"] as? String
                self.email.text = dictionary["email"] as? String
                self.username.text = dictionary["username"] as? String
                self.classesArray = dictionary["classes"] as? [String]
            }
            self.classes.reloadData()
            
        }, withCancel: nil)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            empty.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            empty.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        NSLayoutConstraint.activate([
            search.topAnchor.constraint(equalTo: empty.bottomAnchor, constant: 10),
            search.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            search.heightAnchor.constraint(equalToConstant: 30),
            search.widthAnchor.constraint(equalToConstant: 30)
            ])
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            circle.heightAnchor.constraint(equalToConstant: 130),
            circle.widthAnchor.constraint(equalToConstant: 130)
            ])
        NSLayoutConstraint.activate([
            profilePic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            profilePic.heightAnchor.constraint(equalToConstant: 120),
            profilePic.widthAnchor.constraint(equalToConstant: 120)])
        NSLayoutConstraint.activate([
            username.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            username.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 10),
            username.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            usernameTag.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usernameTag.bottomAnchor.constraint(equalTo: username.bottomAnchor),
            usernameTag.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -75)
            ])
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            name.topAnchor.constraint(equalTo: username.bottomAnchor),
            name.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            nameTag.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameTag.bottomAnchor.constraint(equalTo: name.bottomAnchor),
            nameTag.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -75)
            ])
        NSLayoutConstraint.activate([
            email.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: -55),
            email.topAnchor.constraint(equalTo: name.bottomAnchor),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            emailTag.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emailTag.bottomAnchor.constraint(equalTo: email.bottomAnchor),
            emailTag.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -75)
            ])
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 10),
            line.widthAnchor.constraint(equalToConstant: 1),
            line.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -65),
            line.bottomAnchor.constraint(equalTo: email.bottomAnchor)
            ])
        NSLayoutConstraint.activate([
            classes.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 2 * padding),
            classes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            classes.bottomAnchor.constraint(equalTo: logout.centerYAnchor),
            classes.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        NSLayoutConstraint.activate([
            logout.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logout.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            logout.heightAnchor.constraint(equalToConstant: 50),
            logout.widthAnchor.constraint(equalToConstant: 260)
            ])
    }
    
    @objc func handleSelectProfilePicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profilePic.image = selectedImage
        }
    
    let imageName = NSUUID().uuidString
    
    let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).jpeg")
    
    //    if let uploadData = self.profilePic.image?.pngData()
    if let uploadData = self.profilePic.image?.jpegData(compressionQuality: 0.1) {
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if error != nil {
                print(error)
                return
            }
            storageRef.downloadURL(completion: { (downloadUrl, error) in
                guard let url = downloadUrl?.absoluteString else {return}
                let ref: DatabaseReference = Database.database().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    let usersReference =
                        ref.child("users").child(uid)
                    usersReference.updateChildValues(["profileImageUrl" : url], withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                    })
                }
            })
        })
    }
    
        
        dismiss(animated: true, completion: nil)
        
    }
    
   @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        }
            
        catch let logoutError{
            print(logoutError)
            return
        }
        
        let loginController = LoginController()
        self.present(loginController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (classesArray == [""]) {
            return 0
        }
        return classesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = classes.dequeueReusableCell(withReuseIdentifier: classesCellReuseIdentifier, for: indexPath) as! DepartmentCollectionViewCell
        let department = classesArray[indexPath.item]
        colorNumber = indexPath.item % 3
        
        cell.configure(for: department, number: colorNumber)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (classes.frame.width - padding * 2)
        return CGSize(width: length, height: length * (3/12))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classesViewController  = DetailClassViewController(title: classesArray[indexPath.item])
        navigationController?.pushViewController(classesViewController, animated: true)
    }
}
