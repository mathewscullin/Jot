//
//  DetailClassViewController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/30/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Lottie
import Firebase

protocol stopDelegate: class {
    func add()
    func cancel()
    func present()
    func handleCase(bool: Bool)
}

class DetailClassViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var classTitle : String!
    var jotView : AddJotView!
    var blurView : UIVisualEffectView!
    
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!

    var jotsCollectionView : UICollectionView!
    let padding : CGFloat = 10
    let jotsCellReuseIdentifier = "jotsCellReuseIdentifier"
    
    var alert: UIAlertController!
    
    var checkAnimation: LOTAnimationView!
    
    init(title : String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = title + " Jots"
        classTitle = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.setGradientSmall(colorOne: UIColor(red: 250/255, green: 161/255, blue: 42/255, alpha: 0.6), colorTwo: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 0.6))
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        alert = UIAlertController()
        alert.title = "Invalid Input"
        alert.message = ""
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: .none))
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        let editButton   = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-plus-filled-30"), style: .plain, target: self, action: #selector(handleAdd))
        self.navigationItem.rightBarButtonItem = editButton
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: 0, right: padding)
        
        jotsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        jotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        jotsCollectionView.backgroundColor = .clear
        self.jotsCollectionView.dataSource = self
        self.jotsCollectionView.delegate = self
        jotsCollectionView.alwaysBounceVertical = true
        jotsCollectionView.register(JotCollectionViewCell.self, forCellWithReuseIdentifier: jotsCellReuseIdentifier)
        view.addSubview(jotsCollectionView)
        
        checkAnimation = LOTAnimationView(name: "check")
        checkAnimation.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        checkAnimation.contentMode = .scaleAspectFit
        checkAnimation.isHidden = true
        checkAnimation.alpha = 0.0
        checkAnimation.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(checkAnimation)
        
        setUpConstraints()
        getJots()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            jotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            jotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            jotsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            jotsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    var jotsArray : [Jot] = []
    
    func getJots() {
        jotsArray = []
        let ref = Database.database().reference().child("jots")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let jot = Jot()

                if let images = dictionary["images"] as? [String], let name = dictionary["className"], let descriptor = dictionary["descriptor"], let time = dictionary["timestamp"], let id = dictionary["fromID"]{
                    jot.className = name as? String
                    jot.descriptor = descriptor as? String
                    jot.fromID = id as? String
                    jot.timestamp = time as? NSNumber
                    jot.images = images as? [String]

                }

                if jot.className == self.classTitle {
                    self.jotsArray.append(jot)
                }
                
                DispatchQueue.main.async {
                    self.jotsCollectionView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    @objc func handleAdd() {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        view.addSubview(blurView)
        
        jotView = AddJotView(frame: .zero, title: classTitle)
        jotView.translatesAutoresizingMaskIntoConstraints = false
        jotView.layer.cornerRadius = 10
        jotView.delegate = self
        jotView.alpha = 0
        view.addSubview(jotView)
        
        jotView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5) {
            self.jotView.alpha = 1
            self.blurView.alpha = 1
            self.jotView.transform = CGAffineTransform.identity
        }
        
        NSLayoutConstraint.activate([
            jotView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jotView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            jotView.widthAnchor.constraint(equalToConstant: 5/6*viewWidth),
            jotView.heightAnchor.constraint(equalToConstant: 5/7*viewHeight)
            ])
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func picker() {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
        
        jotView.addImageCollection(image: selectedImageFromPicker)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.fadeOut()
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.checkAnimation.alpha = 0.0
        }, completion: completion)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jotsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = jotsCollectionView.dequeueReusableCell(withReuseIdentifier: jotsCellReuseIdentifier, for: indexPath) as! JotCollectionViewCell
        let jot  = jotsArray[indexPath.item]
        cell.jot = jot
        cell.setNeedsUpdateConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (jotsCollectionView.frame.width - padding * 2)
        return CGSize(width: length, height: length * (2/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let jotViewController = DetailJotViewController(jot: jotsArray[indexPath.item]) 
        navigationController?.pushViewController(jotViewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailClassViewController: stopDelegate {
    func add() {
        getJots()
        UIView.animate(withDuration: 0.5) {
            self.jotView.alpha = 0
            self.blurView.alpha = 0
            self.jotView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.checkAnimation.alpha = 1.0
            self.checkAnimation.isHidden = false
            self.checkAnimation.play()
            self.hide()
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    func cancel() {
        UIView.animate(withDuration: 0.5) {
            self.jotView.alpha = 0
            self.blurView.alpha = 0
            self.jotView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func present () {
        self.picker()
    }
    
    func handleCase(bool: Bool) {
        if bool {
            self.alert.message = "You must have at least one image."
            self.present(self.alert, animated: true)
            return
        }
        else {
            self.alert.message = "Please include a description."
            self.present(self.alert, animated: true)
            return
        }
        
    }
}


