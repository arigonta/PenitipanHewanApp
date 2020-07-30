//
//  UIViewController+Extension.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissView<TSelf: UIViewController>(weakVar: TSelf, closure: ((TSelf) -> Void)? = nil) {
        self.dismiss(animated: true) { [weak weakVar = weakVar] in
            guard let strongVar = weakVar else { return }
            closure?(strongVar)
        }
    }
    
    func goToLogin(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let view = storyboard.instantiateViewController(withIdentifier: "FirstVC") as? FirstStateViewController
        else { return }
        view.modalPresentationStyle = .fullScreen
        
        // To Do: delete cache user Login
        
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
    func goToUserTabbar(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let view = storyboard.instantiateViewController(withIdentifier: "UserTabBarController") as? UserTabBarController
        else { return }
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
    func goToPetshopTabbar(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let view = storyboard.instantiateViewController(withIdentifier: "PetShopTabBarController") as? PetShopTabBarController
            else { return }
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
    func rootToFirstState(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let view = storyboard.instantiateViewController(withIdentifier: "FirstVC") as? FirstStateViewController
        else { return }
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
}
