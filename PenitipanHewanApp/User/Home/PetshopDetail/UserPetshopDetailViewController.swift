//
//  UserPetshopDetailViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 08/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserPetshopDetailViewController: UIViewController {
    
    @IBOutlet weak var imagePetshop: UIImageView!
    @IBOutlet weak var petshopName: UILabel!
    @IBOutlet weak var packagePetshop: UILabel!
    @IBOutlet weak var pricePackage: UILabel!
    @IBOutlet weak var petshopDesc: UILabel!
    @IBOutlet weak var btnHiddenDesc: UIButton!
    @IBOutlet weak var containerDesc: UIView!
    @IBOutlet weak var containerDescTitle: UIView!
    @IBOutlet weak var reservationBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    
    var isHiddenDesc: Bool = true
    var image = UIImage(named: "arrowDown")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }

}

// MARK: - set view
extension UserPetshopDetailViewController {
    func setView() {
        self.title = "Detail Petshop"
        setDescTitle()
        setReservationBtn()
        setChatBtn()
    }
    
    func setDescTitle() {
        // add gesture to 'container title'
        let tapDescTitle = UITapGestureRecognizer(target: self, action: #selector(btnHiddenTap))
        containerDescTitle.isUserInteractionEnabled = true
        containerDescTitle.addGestureRecognizer(tapDescTitle)
        
        // set first containerDesc hidden
        containerDesc.isHidden = isHiddenDesc
        btnHiddenDesc.setImage(image, for: .normal)
        btnHiddenDesc.addTarget(self, action: #selector(btnHiddenTap), for: .touchUpInside)
    }
    
    func setReservationBtn() {
        reservationBtn.setCorner(radius: 8)
        reservationBtn.addTarget(self, action: #selector(reservationTap), for: .touchUpInside)
    }
    
    func setChatBtn() {
        chatBtn.setCornerWithBorder(radius: 8, borderColor: ColorHelper.instance.mainGreen, titleColor: ColorHelper.instance.mainGreen, backgroundColor: .white)
        chatBtn.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
    }
}

// MARK: - objc func
extension UserPetshopDetailViewController {
    @objc private func reservationTap() {
        goToReservationForm()
    }
    
    @objc private func chatTap() {
        // select tabbar
        navigationController?.tabBarController?.selectedIndex = 2
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc private func btnHiddenTap() {
        image = isHiddenDesc ? UIImage(named: "arrowUp") : UIImage(named: "arrowDown")
        isHiddenDesc = isHiddenDesc ? false : true
        containerDesc.isHidden = isHiddenDesc
        btnHiddenDesc.setImage(image, for: .normal)
    }
}

// MARK: - direction
extension UserPetshopDetailViewController {
    func goToReservationForm() {
        let nextVC = UserReservationFormViewController(nibName: "UserReservationFormViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
