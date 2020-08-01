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
    
    
    func initializeHidKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - ALERT
extension UIViewController {
    func openAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
    
    func setAlert(data: AlertModel) {
        let alertVC = UIAlertController(title: data.title, message: data.subtitle, preferredStyle: data.style)
        guard let actions = data.actions else { return }
        actions.forEach {
            let title = $0.title
            let style = $0.style
            let handler = $0.onclick
            let action = UIAlertAction(title: title, style: style, handler: handler)
            alertVC.addAction(action)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}
