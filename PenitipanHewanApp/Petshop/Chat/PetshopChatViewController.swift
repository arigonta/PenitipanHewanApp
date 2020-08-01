//
//  PetshopChatViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import Firebase

class PetshopChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let firestore = Firestore.firestore()
    private var channelRef: CollectionReference {
        return firestore.collection("channels")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        channelRef.addDocument(data: ["name": "test"]) { error in
//            if let error = error {
//                print("error saving chat: \(error.localizedDescription)")
//            }
//        }
    }

}
