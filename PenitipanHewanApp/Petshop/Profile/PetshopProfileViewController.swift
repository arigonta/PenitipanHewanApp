//
//  PetshopProfileViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 30/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit
import CoreData

class PetshopProfileViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        window = appDelegate.window
    }
    
    @IBAction func logoutAction(_ sender: Any) {
//        deleteAllData()
        UserDefaults.standard.removeObject(forKey: CommonHelper.shared.isLogin)
        UserDefaults.standard.removeObject(forKey: CommonHelper.shared.lastRole)
        guard let window = window else { return }
        self.goToLogin(window: window)
    }
    
    private func deleteAllData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Login")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }

}
