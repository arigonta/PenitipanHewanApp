//
//  UIViewController+Extension.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 31/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

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

// MARK: - HIDE KEYBOARD
/*
 
        HOW TO USE:
 
        1. call initializeHidKeyboard(), in viewdidload
 
        override func viewDidLoad() {
            super.viewDidLoad()
            initializeHidKeyboard()
        }
 */

extension UIViewController {
    func initializeHidKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - ALERT
/*
 
        HOW TO USE:
 
        1. create var closure  ((UIAlertAction) -> Void)
        2. call openAlert func
 
 
        let action1: ((UIAlertAction) -> Void) = { _ in
            guard let window = self.window else { return }
            screen.goToLogin(window: window)
        }
 
        openAlert(title: "",
                  message: "Register berhasil!",
                  alertStyle: .alert,
                  actionTitles: ["Ok"],
                  actionStyles: [.default],
                  actions: [action1])
 
 */

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

// MARK: - loading & toast
/*
 
        HOW TO USE:
 
        1. SPINNER (LOADING SCREEN)
        -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 
        showSpinner { spinner in
            
            // do something
            // after end process remove spinner
 
            removeSpinner(spinner)
        }
 
 
        2. SHOW TOAST (POPUP MESSAGE)
        -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 
        showtoast(message: "maaf terjadi kesalahan pada server kami")
        
 */
extension UIViewController {
    
    public func showSpinner(completion: ((UIView) -> Void)? = nil) {
        guard let view = UIApplication.shared.keyWindow ?? self.view else { return }

        let spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        blurView.alpha = 0.9
        
        let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
        indicator.startAnimating()
        
        dispatchMainAsync(weakVar: view) { (view) in
            spinnerView.addSubview(blurView)
            blurView.snp.makeConstraints { make in
                make.width.equalTo(spinnerView.snp.width).multipliedBy(0.5)
                make.height.equalTo(blurView.snp.width).multipliedBy(0.75)
                make.center.equalToSuperview()
            }
            spinnerView.addSubview(indicator)
            view.addSubview(spinnerView)
            spinnerView.alpha = 0
            indicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                spinnerView.alpha = 1
            }, completion: nil)
        }
        completion?(spinnerView)
    }
    
    public func removeSpinner(_ spinner: UIView) {
        dispatchMainAsync {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                spinner.alpha = 0
            }, completion: { _ in
                spinner.removeFromSuperview()
            })
        }
    }
    
    func showToast(message: String) {
        let toastContainer: UIView = .init()
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds  =  true

        let toastLabel: UILabel = .init()
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 13)
        
        view.addSubview(toastContainer)
        toastContainer.addSubview(toastLabel)
        
        toastContainer.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(64)
            make.trailing.equalToSuperview().offset(-64)
            make.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { (make) in
            let padding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
            make.edges.equalToSuperview().inset(padding)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

// MARK: - keyboard will increase the view position
/*
 
        HOW TO USE:
 
        1. create IBOutlet UIScrollView
        2. create var activeComponent: UIView? on global variable
        3. then call func as follows:
     
         override public func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             registerForKeyboardNotifications(scrollView: scrollView, activeComponent: activeComponent)
         }

         override public func viewDidDisappear(_ animated: Bool) {
             super.viewDidDisappear(animated)
             deregisterFromKeyboardNotifications()
         }
    
 */

extension UIViewController {
    func registerForKeyboardNotifications(scrollView: UIScrollView, activeComponent: UIView?) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWasShown(notification: notification, scrollView: scrollView, activeComponent: activeComponent)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (notification) in
            self.keyboardWillBeHidden(notification: notification, scrollView: scrollView)
        }
    }

    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(notification: Notification, scrollView: UIScrollView?, activeComponent: UIView? ) {
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let keyboardHeight = keyboardSize?.height ?? 0
        if let scrollView = scrollView {
            let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)

            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets

            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardHeight
            if let activeComponent = activeComponent {
                if !aRect.contains(activeComponent.frame.origin) {
                    scrollView.scrollRectToVisible((activeComponent.frame), animated: true)
                }
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: Notification, scrollView: UIScrollView?) {
        if let scrollView = scrollView {
            let contentInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}
