//
//  PetShopTabBarController.swift
//  PenitipanHewanApp
//
//  Created by Ari Gonta on 28/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class PetShopTabBarController: UITabBarController {
        
    let colorUtils = ColorHelper.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setTabbar()
    }
    

    private func setTabbar() {
        
        self.tabBar.tintColor = colorUtils.mainGreen
        
        
        let shopNC = UIStoryboard(name: "ShopStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ShopNav") as! UINavigationController
        let monitoringNC = UIStoryboard(name: "PetshopMonitoringStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PetshopMonitoringNav") as! UINavigationController
        let chatNC = UIStoryboard(name: "PetshopChatStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PetshopChatNav") as! UINavigationController
        let profileNC = UIStoryboard(name: "PetshopProfileStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PetshopProfileNav") as! UINavigationController
        
        let view1 = shopNC.viewControllers.first as? ShopViewController
        let view2 = monitoringNC.viewControllers.first as? PetshopMonitoringViewController
        let view3 = chatNC.viewControllers.first as? PetshopChatViewController
        let view4 = profileNC.viewControllers.first as? PetshopProfileViewController
        
        let icon1 = UITabBarItem(title: "Shop", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
        let icon2 = UITabBarItem(title: "Monitoring", image: UIImage(named: "pet"), selectedImage: UIImage(named: "pet"))
        let icon3 = UITabBarItem(title: "Chat", image: UIImage(named: "chat"), selectedImage: UIImage(named: "chat"))
        let icon4 = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        
        view1?.tabBarItem = icon1
        view2?.tabBarItem = icon2
        view3?.tabBarItem = icon3
        view4?.tabBarItem = icon4
        
        let controllers = [shopNC, monitoringNC, chatNC, profileNC] as [UIViewController]
        setViewControllers(controllers, animated: false)
    }

}

extension PetShopTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}
