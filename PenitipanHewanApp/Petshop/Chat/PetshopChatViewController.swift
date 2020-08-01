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
    
    private let firestore = Firestore.firestore()
    private var channelRef: CollectionReference {
        return firestore.collection("channels")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        channelRef.addDocument(data: ["name": "test"]) { error in
            if let error = error {
                print("error saving chat: \(error.localizedDescription)")
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
