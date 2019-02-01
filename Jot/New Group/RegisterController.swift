//
//  RegisterControllerViewController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegisterController: UIViewController {
    
    var alp : UIImageView!
    var input : UIView!
    var name : UITextField!
    var username: UITextField!
    var email: UITextField!
    var password: UITextField!
    var register : UIButton!
    var account : UILabel!
    var signIn : UIButton!
    
    var alert: UIAlertController!
    
    var line : UIView!
    var nameLine : UIView!
    var userLine : UIView!
    var emailLine : UIView!
    
    var loading : UIView!
    var loadAnimation: LOTAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.setGradient(colorOne: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 0.8), colorTwo: UIColor(red: 255/255, green: 161/255, blue: 42/255, alpha: 0.8))
        
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gesture:)))
        view.addGestureRecognizer(tapToDismiss)
        
        alp = UIImageView()
        alp.translatesAutoresizingMaskIntoConstraints = false
        alp.contentMode = .scaleAspectFit
        alp.image = #imageLiteral(resourceName: "alp")
        alp.clipsToBounds = true
        view.addSubview(alp)
        
        input = UIView()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        input.layer.cornerRadius = 8
        view.addSubview(input)
        
        register = UIButton()
        register.translatesAutoresizingMaskIntoConstraints = false
        register.backgroundColor = .clear
        register.setTitle("Register", for: .normal)
        register.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        register.titleLabel?.textAlignment = .center
        register.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        register.layer.borderWidth = 1
        register.layer.borderColor = UIColor.white.cgColor
        register.layer.cornerRadius = 8
        view.addSubview(register)
        
        line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        view.addSubview(line)
        
        name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.backgroundColor = .clear
        name.textColor = .white
        name.attributedPlaceholder = NSAttributedString(string: "Name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        name.font = .systemFont(ofSize: 18, weight: .regular)
        input.addSubview(name)
        
        nameLine = UIView()
        nameLine.translatesAutoresizingMaskIntoConstraints = false
        nameLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.addSubview(nameLine)
        
        username = UITextField()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.backgroundColor = .clear
        username.textColor = .white
        username.attributedPlaceholder = NSAttributedString(string: "Username",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        username.font = .systemFont(ofSize: 18, weight: .regular)
        input.addSubview(username)
        
        userLine = UIView()
        userLine.translatesAutoresizingMaskIntoConstraints = false
        userLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.addSubview(userLine)
        
        email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.backgroundColor = .clear
        email.textColor = .white
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.font = .systemFont(ofSize: 18, weight: .regular)
        input.addSubview(email)
        
        emailLine = UIView()
        emailLine.translatesAutoresizingMaskIntoConstraints = false
        emailLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        input.addSubview(emailLine)
        
        password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = .clear
        password.textColor = .white
        password.isSecureTextEntry = true
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password.font = .systemFont(ofSize: 18, weight: .regular)
        input.addSubview(password)
        
        account = UILabel()
        account.translatesAutoresizingMaskIntoConstraints = false
        account.text = "Already have an account?"
        account.font = .systemFont(ofSize: 16, weight: .light)
        account.textColor = .white
        view.addSubview(account)
        
        signIn = UIButton()
        signIn.translatesAutoresizingMaskIntoConstraints = false
        signIn.setTitle(" Sign In!", for: .normal)
        signIn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        signIn.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        view.addSubview(signIn)
        
        alert = UIAlertController()
        alert.title = "Invalid Input"
        alert.message = ""
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: .none))
        
        loading = UIView()
        loading.setGradient(colorOne: UIColor(red: 219/255, green: 105/255, blue: 153/255, alpha: 1.0), colorTwo: UIColor(red: 255/255, green: 161/255, blue: 42/255, alpha: 1.0))
        loading.isHidden = true
        loading.alpha = 0.0
        view.addSubview(loading)
        
        loadAnimation = LOTAnimationView(name: "loading")
        loadAnimation.frame = CGRect(x: 0, y: 0, width: 800, height: 800)
        loadAnimation.contentMode = .scaleAspectFit
        loadAnimation.isHidden = true
        loadAnimation.alpha = 0
        loadAnimation.center = CGPoint(x: view.center.x, y: view.center.y)
        view.addSubview(loadAnimation)
        
        
        
        setUpConstraints()
        setUpInput()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadAnimation.isHidden = true
        self.loading.isHidden = true
    }
    
    func setUpInput() {
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: input.topAnchor),
            name.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 20),
            name.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -20),
            name.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        NSLayoutConstraint.activate([
            nameLine.bottomAnchor.constraint(equalTo: input.topAnchor, constant: 51),
            nameLine.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 10),
            nameLine.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -10),
            nameLine.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: nameLine.topAnchor),
            username.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 20),
            username.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -20),
            username.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            userLine.bottomAnchor.constraint(equalTo: nameLine.topAnchor, constant: 52),
            userLine.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 10),
            userLine.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -10),
            userLine.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo: userLine.topAnchor),
            email.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 20),
            email.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -20),
            email.heightAnchor.constraint(equalToConstant: 50)
            ])
        NSLayoutConstraint.activate([
            emailLine.bottomAnchor.constraint(equalTo: userLine.topAnchor, constant: 52),
            emailLine.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 10),
            emailLine.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -10),
            emailLine.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: emailLine.topAnchor),
            password.leadingAnchor.constraint(equalTo: input.leadingAnchor, constant: 20),
            password.trailingAnchor.constraint(equalTo: input.trailingAnchor, constant: -20),
            password.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            alp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alp.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            alp.heightAnchor.constraint(equalToConstant: 250)])
        NSLayoutConstraint.activate([
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            input.topAnchor.constraint(equalTo: alp.bottomAnchor, constant: 15),
            input.heightAnchor.constraint(equalToConstant: 200)])
        NSLayoutConstraint.activate([
            register.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            register.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            register.topAnchor.constraint(equalTo: input.bottomAnchor, constant: 30),
            register.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([
            line.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            account.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            account.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -32)
            ])
        NSLayoutConstraint.activate([
            signIn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -9),
            signIn.leadingAnchor.constraint(equalTo: account.trailingAnchor)
            ])
    }
    
    @objc func handleRegister() {
        
        guard let emailText = email.text, emailText != "", let passwordText = password.text, passwordText != "", let nameText = name.text, nameText != "", let usernameText = username.text, usernameText != "" else {
            self.alert.title = "Invalid Input"
            self.alert.message = ""
            if (username.text == "") {
                self.alert.message = self.alert.message! + "Username must not be empty.\n"
            }
            if (name.text == "") {
                self.alert.message = self.alert.message! + "Name must not be empty.\n"
            }
            if (email.text == "") {
                self.alert.message = self.alert.message! + "Enter a valid email.\n"
            }
            if (password.text == "") {
                self.alert.message = self.alert.message! +  "Password must be at least 6 characters."
            }
            self.present(alert, animated: true)
            return
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (authResult, error) in
             if error != nil {
                let errorMessage = error!.localizedDescription
                self.alert.title = "Invalid Input"
                if (errorMessage.contains("The email address is badly formatted.")) {
                    self.alert.message = "Email must be valid."
                }
                if (errorMessage.contains("The email address is already in use by another account.")) {
                    self.alert.message = "Email already in use."
                }
                if (errorMessage.contains("The password must be 6 characters long or more.")) {
                    self.alert.message = "Password must be at least 6 characters."
                }
                self.present(self.alert, animated: true)
                return
            }
            
            guard let uid = authResult?.user.uid else {return}

            let profileImageUrl = ""
            let classes : [String] = [""]
            
            var ref: DatabaseReference!
            ref = Database.database().reference(fromURL: "https://jot-app-cfe42.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name" : nameText, "username" : usernameText, "email" : emailText, "password" : passwordText, "profileImageUrl" : profileImageUrl, "classes" : classes] as [String : Any]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
                NSLayoutConstraint.activate([
                    self.loading.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.loading.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.loading.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.loading.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                    ])
                
                self.loading.isHidden = false
                self.loadAnimation.isHidden = false
                self.fadeIn()
                self.holdUp()
            })
            
    })
    
    }
    
    @objc func handleSignIn() {
        let loginController = LoginController()
        self.present(loginController, animated: false, completion: nil)
    }
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

 }

extension RegisterController {
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.loadAnimation.play()
            self.loadAnimation.loopAnimation = true
            self.loading.alpha = 1.0
            self.loadAnimation.alpha = 1.0
        }, completion: completion)
    }
    func holdUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            self.loadAnimation.loopAnimation = true
            let mainVC = MainTabBarController()
            self.present(mainVC, animated: true, completion: nil)
        }
    }
}

