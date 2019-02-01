//
//  ExploreController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class ExploreController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var departments : UICollectionView!
    var departmentsArray : [String]!
    let padding : CGFloat = 10
    let departmentsCellReuseIdentifier = "departmentsCellReuseIdentifier"
    
    var emptyView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Departments"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 1))
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyView)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        departments = UICollectionView(frame: .zero, collectionViewLayout: layout)
        departments.translatesAutoresizingMaskIntoConstraints = false
        departments.backgroundColor = .white
        departments.dataSource = self
        departments.delegate = self
        departments.alwaysBounceVertical = true
        departments.register(DepartmentCollectionViewCell.self, forCellWithReuseIdentifier: departmentsCellReuseIdentifier)
        view.addSubview(departments)
        
        departmentsArray = ["CHEME", "CS", "ENGRD", "ENGRI", "INFO", "MATH", "PHYS"]
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            departments.topAnchor.constraint(equalTo: emptyView.bottomAnchor, constant: padding - 1),
            departments.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            departments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            departments.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return departmentsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = departments.dequeueReusableCell(withReuseIdentifier: departmentsCellReuseIdentifier, for: indexPath) as! DepartmentCollectionViewCell
        let department = departmentsArray[indexPath.item]
        let colorNumber = indexPath.item % 3
        
        cell.configure(for: department, number: colorNumber)
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (departments.frame.width - padding * 3) / 2.0
        return CGSize(width: length, height: length * (2/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classesViewController  = ClassesViewController(branch: departmentsArray[indexPath.item])
        navigationController?.pushViewController(classesViewController, animated: true)
    }
}
