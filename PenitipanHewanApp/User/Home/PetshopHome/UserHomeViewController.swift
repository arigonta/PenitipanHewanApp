//
//  UserHomeViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setViewFirst()
    }
    
    private func setViewFirst() {
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
        imageView4.isUserInteractionEnabled = true
        
        let tapImage1 = UITapGestureRecognizer(target: self, action: #selector(image1Tapped))
        let tapImage2 = UITapGestureRecognizer(target: self, action: #selector(image2Tapped))
        let tapImage3 = UITapGestureRecognizer(target: self, action: #selector(image3Tapped))
        let tapImage4 = UITapGestureRecognizer(target: self, action: #selector(image4Tapped))
        
        imageView1.addGestureRecognizer(tapImage1)
        imageView2.addGestureRecognizer(tapImage2)
        imageView3.addGestureRecognizer(tapImage3)
        imageView4.addGestureRecognizer(tapImage4)
    }
    
    @objc private func image1Tapped() {
        directToPetShoplist("Kucing")
    }
    @objc private func image2Tapped() {
        directToPetShoplist("Anjing")
    }
    @objc private func image3Tapped() {
        directToPetShoplist("Burung")
    }
    @objc private func image4Tapped() {
        directToPetShoplist("Reptile")
    }
    
    private func directToPetShoplist(_ petType: String) {
        let nextVC = UserPetshopViewController(nibName: "UserPetshopViewController", bundle: nil)
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.petType = petType
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
