//
//  UserPetshopDetailViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 08/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Kingfisher

protocol UserPetshopDetailViewProtocol: class {
    func updateScreen(petshopData: UserModel?)
}

class UserPetshopDetailViewController: UIViewController {
    
    @IBOutlet weak var imagePetshop: UIImageView!
    @IBOutlet weak var petshopName: UILabel!
    @IBOutlet weak var packagePetshop: UILabel!
    @IBOutlet weak var pricePackage: UILabel!
    @IBOutlet weak var phonePetshopLbl: UILabel!
    @IBOutlet weak var addressPetshop: UILabel!
    @IBOutlet weak var petshopDesc: UILabel!
    @IBOutlet weak var btnHiddenDesc: UIButton!
    @IBOutlet weak var containerDesc: UIView!
    @IBOutlet weak var containerDescTitle: UIView!
    @IBOutlet weak var reservationBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Var
    lazy var refreshController: UIRefreshControl = .init()
    var dataDetail: PetShopListModel?
    var presenter: UserPetshopDetailPresenterProtocol?
    var isHiddenDesc: Bool = true
    var image = UIImage(named: "arrowDown")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        presenter = UserPetshopDetailPresenter(view: self)
        if let petshopId = dataDetail?.petshop_id {
            presenter?.getDetailPetshop(self, petshopId)
        }
    }

}

// MARK: - set view
extension UserPetshopDetailViewController {
    func setView() {
        self.title = "Detail Petshop"
        
        setDescTitle()
        setReservationBtn()
        setChatBtn()
        setData()
        
        scrollView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    
    @objc func refreshView() {
        if let petshopId = dataDetail?.petshop_id {
            presenter?.getDetailPetshop(self, petshopId)
        }
        refreshController.endRefreshing()
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
    
    func setData() {
        self.imagePetshop.layer.cornerRadius = 10
        if let photo = dataDetail?.petshop_photo, !photo.isEmpty {
            let url = URL(string: photo)
            self.imagePetshop.kf.setImage(with: url)
        } else {
            self.imagePetshop.image = #imageLiteral(resourceName: "defaultEmptyPhoto")
        }
        petshopName.backgroundColor = ColorHelper.instance.mainGreen
        petshopName.layer.cornerRadius = 10
        petshopName.layer.masksToBounds = true
        petshopName.textColor = .white
        petshopName.text = dataDetail?.petshop_name ?? "Petshop Name"
        packagePetshop.text = "\(dataDetail?.duration ?? 0) Hari"
        pricePackage.text = "\(dataDetail?.price ?? 0)".currencyInputFormatting()
        petshopDesc.text = dataDetail?.deskripsi ?? "-Tidak ada Deskripsi paket"
        phonePetshopLbl.text = "_"
        addressPetshop.text = "_"
    }
}

// MARK: - objc func
extension UserPetshopDetailViewController {
    @objc private func reservationTap() {
        guard let model = dataDetail else { return }
        presenter?.directToReservationForm(self, petshopDetailModel: model)
    }
    
    @objc private func chatTap() {
        // select tabbar
        presenter?.directToChat(self)
    }
    
    @objc private func btnHiddenTap() {
        image = isHiddenDesc ? UIImage(named: "arrowUp") : UIImage(named: "arrowDown")
        isHiddenDesc = isHiddenDesc ? false : true
        containerDesc.isHidden = isHiddenDesc
        btnHiddenDesc.setImage(image, for: .normal)
    }
}

extension UserPetshopDetailViewController: UserPetshopDetailViewProtocol {
    func updateScreen(petshopData: UserModel?) {
        phonePetshopLbl.text = petshopData?.phone ?? ""
        addressPetshop.text = petshopData?.address ?? ""
    }
}
