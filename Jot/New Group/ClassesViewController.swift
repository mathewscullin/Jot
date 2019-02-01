//
//  ClassesViewController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/29/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit

protocol addOrCancel: class {
    func stop ()
}

class ClassesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var classes : UICollectionView!
    var classesArray : [String]!
    let padding : CGFloat = 10
    let classesCellReuseIdentifier = "classesCellReuseIdentifier"
    
    
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    
    var addView : AddClassView!
    var blurView: UIVisualEffectView!
    
    var emptyView : UIView!
    
    
    var loading : UIView!
    
    init(branch : String) {
        super.init(nibName: nil, bundle: nil)
        switch branch {
            case "CHEME" : classesArray = ["CHEME 2880", "CHEME 3130", "CHEME 3240", "CHEME 4010", "CHEME 4220", "CHEME 4320", "CHEME 4610", "CHEME 4710"]
            case "CS" : classesArray = ["CS 1110", "CS 1112", "CS 1330", "CS 2800", "CS 3110", "CS 3410", "CS 4320", "CS 4410", "CS 4700", "CS 4780"]
            case "ENGRD" : classesArray = ["ENGRD 2020", "ENGRD 2100", "ENGRD 2110", "ENGRD 2112", "ENGRD 2140", "ENGRD 2300", "ENGRD 2600"]
            case "ENGRI" : classesArray = ["ENGRI 1101", "ENGRI 1200", "ENGRI 1210", "ENGRI 1220", "ENGRI 1310", "ENGRI 1510"]
            case "INFO" : classesArray = ["INFO 1300", "INFO 2300"]
            case "MATH" : classesArray = ["MATH 1910", "MATH 1920", "MATH 2940"]
            case "PHYS" : classesArray = ["PHYS 2112"]
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewHeight = view.frame.height
        viewWidth = view.frame.width
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Classes"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
        
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
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
    
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            classes.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: padding),
            classes.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            classes.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            classes.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = classes.dequeueReusableCell(withReuseIdentifier: classesCellReuseIdentifier, for: indexPath) as! DepartmentCollectionViewCell
        let department = classesArray[indexPath.item]
        let colorNumber = indexPath.item % 3
        
        cell.configure(for: department, number: colorNumber)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (classes.frame.width - padding * 3) / 2.0
        return CGSize(width: length, height: length * (2/3))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0
        view.addSubview(blurView)
        
        addView = AddClassView(frame: .zero, viewHeight: viewHeight, viewWidth: viewWidth, title: classesArray[indexPath.item])
        addView.translatesAutoresizingMaskIntoConstraints = false
        addView.layer.cornerRadius = 10
        addView.delegate = self
        addView.alpha = 0
        view.addSubview(addView)
        
        addView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        UIView.animate(withDuration: 0.5) {
            self.addView.alpha = 1
            self.blurView.alpha = 1
            self.addView.transform = CGAffineTransform.identity
        }
        
        NSLayoutConstraint.activate([
            addView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            addView.widthAnchor.constraint(equalToConstant: 3/5*viewWidth),
            addView.heightAnchor.constraint(equalToConstant: 2/5*viewWidth)
            ])
    }
}

extension ClassesViewController: addOrCancel {
    func stop() {
        UIView.animate(withDuration: 0.5) {
            self.addView.alpha = 0
            self.blurView.alpha = 0
            self.addView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
}
