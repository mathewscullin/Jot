//
//  AddClassView.swift
//  Jot
//
//  Created by Mathew Scullin on 1/29/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class AddClassView: UIView {

    weak var delegate: addOrCancel?
    
    var questionPtOne : UILabel!
    var classTitle : UILabel!
    var questionPtTwo : UILabel!
    
    var add : UIButton!
    var cancel : UIButton!

    init(frame: CGRect, viewHeight: CGFloat, viewWidth: CGFloat, title: String) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        

        
        questionPtOne = UILabel()
        questionPtOne.translatesAutoresizingMaskIntoConstraints = false
        questionPtOne.text = "Would you like to add"
        questionPtOne.font = .systemFont(ofSize: 18, weight: .regular)
        questionPtOne.textAlignment = .center
        questionPtOne.textColor = .black
        self.addSubview(questionPtOne)
        NSLayoutConstraint.activate([
            questionPtOne.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            questionPtOne.topAnchor.constraint(equalTo: self.topAnchor, constant: 20)
            ])
        
        classTitle = UILabel()
        classTitle.translatesAutoresizingMaskIntoConstraints = false
        classTitle.text = title
        classTitle.font = .systemFont(ofSize: 22, weight: .medium)
        classTitle.textAlignment = .center
        classTitle.textColor = .black
        self.addSubview(classTitle)
        NSLayoutConstraint.activate([
            classTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            classTitle.topAnchor.constraint(equalTo: questionPtOne.bottomAnchor)
            ])
        
        questionPtTwo = UILabel()
        questionPtTwo.translatesAutoresizingMaskIntoConstraints = false
        questionPtTwo.text = "to your classes?"
        questionPtTwo.font = .systemFont(ofSize: 18, weight: .regular)
        questionPtTwo.textAlignment = .center
        questionPtTwo.textColor = .black
        self.addSubview(questionPtTwo)
        
        NSLayoutConstraint.activate([
            questionPtTwo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            questionPtTwo.topAnchor.constraint(equalTo: classTitle.bottomAnchor)
            ])
        
        add = UIButton()
        add.translatesAutoresizingMaskIntoConstraints = false
        add.setTitle("    Add    ", for: .normal)
        add.backgroundColor = UIColor(red: 80/255, green: 225/255, blue: 100/255, alpha: 1.0)
        add.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        add.tintColor = .white
        add.layer.cornerRadius = 5
        add.clipsToBounds = true
        add.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        self.addSubview(add)
        NSLayoutConstraint.activate([
            add.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            add.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
        
        cancel = UIButton()
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.backgroundColor = .lightGray
        cancel.setTitle("  Cancel  ", for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cancel.layer.cornerRadius = 5
        cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        self.addSubview(cancel)
        NSLayoutConstraint.activate([
            cancel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cancel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleAdd() {
                changeClasses()
                self.delegate?.stop()
    }
    
    @objc func handleCancel() {
        self.delegate?.stop()
    }
    
    func changeClasses() {
        var i = 0 // using incrementer because if not the second if let would repeat itself infinitely.
        let ref: DatabaseReference = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
                while i < 1 {
                if let dictionary = snapshot.value as? [String : AnyObject], let classT = self.classTitle.text {
                    let usersReference = ref.child("users").child(uid)
                    var array = dictionary["classes"] as? [String]
                    if array == [""] {
                        i = i + 1
                        usersReference.updateChildValues((["classes" : [classT]]), withCompletionBlock: { (err, ref) in
                            if err != nil {
                              print(err)
                              return
                            }
                        })
                   }
                    else {
                        array?.append(classT)
                        i = i + 1
                       usersReference.updateChildValues((["classes" : array]), withCompletionBlock: { (err, ref) in                            if err != nil {
                                print(err)
                               return
                            }
                        })
                    }
                }
            }
            }
        }
    }
    
}

