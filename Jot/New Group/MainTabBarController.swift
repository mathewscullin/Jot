//
//  MainTabBarController.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    var explore : UIButton!
    var profile : UIButton!
    
    var exploreV : ExploreController!
    var profileV : ProfileController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        tabBar.shadowImage = UIImage()
        
        setUpTabBar()
    }
    
    func setUpTabBar() {
        
        exploreV = ExploreController()
        profileV = ProfileController()
        
        let exploreController = createNavContoller(vc: exploreV, selectedImage: #imageLiteral(resourceName: "icons8-search-33"), unselectedImage: #imageLiteral(resourceName: "icons8-search-32"))
        let profileController = createNavContoller(vc: profileV, selectedImage: #imageLiteral(resourceName: "icons8-customer-filled-33"),
                                                   unselectedImage: #imageLiteral(resourceName: "icons8-customer-filled-32"))
        
        viewControllers = [exploreController, profileController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0) 
        }
        
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
        self.present(loginController, animated: false, completion: nil)
    }
    
}

extension UITabBarController {
    func createNavContoller(vc : UIViewController, selectedImage: UIImage, unselectedImage: UIImage) -> UINavigationController {
        let viewContoller = vc
        let navController = UINavigationController(rootViewController: viewContoller)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
}
