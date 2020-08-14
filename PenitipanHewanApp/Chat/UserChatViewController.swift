//
//  UserChatViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 29/07/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import UIKit

protocol UserChatViewProtocol {
    func addChannelToTable(_ channel: ChannelModel)
    func updateChannelInTable(_ channel: ChannelModel)
    func removeChannelFromTable(_ channel: ChannelModel)
}
class UserChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var petshopId: String = UserDefaultsUtils.shared.getPetshopId()
    private var channels = [ChannelModel]()
    private var role: String = UserDefaultsUtils.shared.getRole()
    private var currentUsername: String = UserDefaultsUtils.shared.getUsername()
    
    var presenter: UserChatPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = UserChatPresenter(self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createChannelOrFetch()
        setTable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.removeListener()
    }
    
    func createChannelOrFetch() {
        petshopId = UserDefaultsUtils.shared.getPetshopId()
        if role.elementsEqual("customer") {
            if !petshopId.isEmpty {
                presenter?.createChannels(self, petshopId)
            } else {
                presenter?.channelListen(self, currentUsername)
            }
        } else {
            presenter?.channelListen(self, CommonHelper.dummyPetshopId)
        }
        
    }

}

// MARK: - table
extension UserChatViewController {
    func setTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension UserChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = channels[indexPath.row]
        let text = currentUsername == data.customerId ? data.petshopId : data.customerId
        presenter?.directToChatDetail(self, text)
    }
}

extension UserChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = channels[indexPath.row]
        let text = currentUsername == data.customerId ? data.petshopId : data.customerId
        cell.textLabel?.text = text
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}


extension UserChatViewController: UserChatViewProtocol {
    func addChannelToTable(_ channel: ChannelModel) {
        guard !self.channels.contains(channel) else { return }
        channels.append(channel)
        channels.sort()
        guard let index = channels.firstIndex(of: channel) else { return }
        let indexPath = [IndexPath(row: index, section: 0)]
        tableView.insertRows(at: indexPath, with: .automatic)
    }
    
    func updateChannelInTable(_ channel: ChannelModel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels[index] = channel
        let indexPath = [IndexPath(row: index, section: 0)]
        tableView.reloadRows(at: indexPath, with: .automatic)
    }
    
    func removeChannelFromTable(_ channel: ChannelModel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        let indexPath = [IndexPath(row: index, section: 0)]
        tableView.deleteRows(at: indexPath, with: .automatic)
    }
    
}
