//
//  ViewController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class LoginController: UIViewController {
    
    var alp : UIImageView!
    var email : UITextField!
    var password : UITextField!
    var login : UIButton!
    var register : UILabel!
    var signUp : UIButton!
    
    var alert: UIAlertController!
    
    var line : UIView!
    
    var loading : UIView!
    var loadAnimation: LOTAnimationView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadAnimation.isHidden = true
        self.loading.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        email.textColor = .white
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.email.frame.height))
        email.leftView = paddingView1
        email.leftViewMode = UITextField.ViewMode.always
        email.attributedPlaceholder = NSAttributedString(string: "Email",
                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        email.font = .systemFont(ofSize: 18, weight: .regular)
        email.layer.cornerRadius = 8
        view.addSubview(email)
        
        password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        password.textColor = .white
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.password.frame.height))
        password.leftView = paddingView2
        password.leftViewMode = UITextField.ViewMode.always
        password.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        password.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password.font = .systemFont(ofSize: 18, weight: .regular)
        password.layer.cornerRadius = 8
        password.isSecureTextEntry = true
        view.addSubview(password)
        
        login = UIButton()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.backgroundColor = .clear
        login.setTitle("Login", for: .normal)
        login.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        login.titleLabel?.textAlignment = .center
        login.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        login.layer.borderWidth = 1
        login.layer.borderColor = UIColor.white.cgColor
        login.layer.cornerRadius = 8
        view.addSubview(login)
        
        register = UILabel()
        register.translatesAutoresizingMaskIntoConstraints = false
        register.text = "Don't have an account?"
        register.font = .systemFont(ofSize: 16, weight: .light)
        register.textColor = .white
        view.addSubview(register)
        
        signUp = UIButton()
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setTitle(" Sign Up!", for: .normal)
        signUp.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        signUp.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        view.addSubview(signUp)
        
        line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        view.addSubview(line)
        
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
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            alp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alp.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            alp.heightAnchor.constraint(equalToConstant: 250)])
        NSLayoutConstraint.activate([
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            email.topAnchor.constraint(equalTo: alp.bottomAnchor, constant: 15),
            email.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 30),
            password.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([
            login.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            login.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            login.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 30),
            login.heightAnchor.constraint(equalToConstant: 50)])
        NSLayoutConstraint.activate([
            line.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1)
            ])
        NSLayoutConstraint.activate([
            register.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            register.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -32)
            ])
        NSLayoutConstraint.activate([
            signUp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -9),
            signUp.leadingAnchor.constraint(equalTo: register.trailingAnchor)
            ])
    }

    @objc func handleLogin() {
        guard let emailText = email.text, emailText != "", let passwordText = password.text, passwordText != "" else {
            self.alert.title = "Invalid Input"
            self.alert.message = ""
            if (email.text == "") {
                self.alert.message = self.alert.message! + "Email is incorrect.\n"
            }
            if (password.text == "") {
                self.alert.message = self.alert.message! +  "Incorrect Password"
            }
            self.present(alert, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { (user, error) in
            if error != nil {
                print(error)
                self.alert.title = "Invalid Input"
                self.alert.message = "Either your email or your password was incorrect."
                self.present(self.alert, animated: true)
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
            self.loadAnimation.loopAnimation = true
            self.fadeIn()
            self.holdUp()
            
        }
    }
    
    @objc func handleSignUp() {
        let registerController = RegisterController()
        self.present(registerController, animated: false, completion: nil)
    }
}

extension LoginController {
    
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
    
    @objc func viewTapped(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

