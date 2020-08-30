//
//  UserHomeViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

protocol UserHomeViewProtocol: class {
    func update()
}

class UserHomeViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Var
    lazy var refreshController: UIRefreshControl = .init()
    var presenter: UserHomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Home"
        
        presenter = UserHomePresenter(self)
        setViewFirst()
        presenter?.getReferenceAnimalType(self)
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
        
        scrollView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    
    @objc private func image1Tapped() {
        presenter?.checkData(self, "Kucing")
    }
    @objc private func image2Tapped() {
        presenter?.checkData(self, "Anjing")
    }
    @objc private func image3Tapped() {
        presenter?.checkData(self, "Burung")
    }
    @objc private func image4Tapped() {
        presenter?.checkData(self, "Reptil")
    }
    @objc private func refreshView() {
        presenter?.getReferenceAnimalType(self)
        refreshController.endRefreshing()
    }

}

extension UserHomeViewController: UserHomeViewProtocol {
    func update() {
        
    }
}
