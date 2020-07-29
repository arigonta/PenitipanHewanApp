//
//  UserTabBarController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Foundation

class UserTabBarController: UITabBarController {
    
    let colorUtils = ColorHelper.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setTabbar()
    }
    

    private func setTabbar() {
        
        self.tabBar.tintColor = colorUtils.mainGreen
        
        
        let homeNC = UIStoryboard(name: "UserHomeStoryboard", bundle: nil).instantiateViewController(withIdentifier: "UserHomeNav") as! UINavigationController
        let profileNC = UIStoryboard(name: "UserProfileStoryboard", bundle: nil).instantiateViewController(withIdentifier: "UserProfileNav") as! UINavigationController
        let chatNC = UINavigationController(rootViewController: UserChatViewController())
        let petNC = UIStoryboard(name: "UserPetStoryboard", bundle: nil).instantiateViewController(withIdentifier: "UserPetNav") as! UINavigationController
        
        let view1 = homeNC.viewControllers.first as? UserHomeViewController
        let view4 = profileNC.viewControllers.first as? UserProfileViewController
        let view2 = petNC.viewControllers.first as? UserPetViewController
        let view3 = chatNC.viewControllers.first as? UserChatViewController
        
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        let icon4 = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        let icon2 = UITabBarItem(title: "Chat", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat"))
        let icon3 = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        
        view1?.tabBarItem = icon1
        view2?.tabBarItem = icon2
        view3?.tabBarItem = icon3
        view4?.tabBarItem = icon4
        
        let controllers = [homeNC, petNC, chatNC, profileNC] as [UIViewController]
        setViewControllers(controllers, animated: false)
    }

}

extension UserTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
