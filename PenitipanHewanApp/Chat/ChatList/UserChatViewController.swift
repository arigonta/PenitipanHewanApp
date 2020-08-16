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
                presenter?.channelListen(self)
            }
        } else {
            presenter?.channelListen(self)
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
        presenter?.directToChatDetail(self, data)
    }
}

extension UserChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.isEmpty ? 1: channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if channels.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyChatCell", for: indexPath) as? emptyChatCell else {
                return UITableViewCell()
            }
            tableView.separatorStyle = .none
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCellTableViewCell", for: indexPath) as? ChatListCellTableViewCell else {
                tableView.separatorStyle = .none
                return UITableViewCell()
            }
            let data = channels[indexPath.row]
            let text = currentUsername == data.customerId ? data.petshopId : data.customerId
            cell.nameLbl.text = text
            cell.lastMessageLbl.text = data.lastMessage.isEmpty ? " " : data.lastMessage
            cell.lastMessageCreatedLbl.text = data.lastMessage.isEmpty ? "" : CommonHelper.shared.dateToString(from: data.lastMessageCreated)
            cell.selectionStyle = .none
            tableView.separatorStyle = .singleLine
            return cell
        }
        
    }
}

// MARK: - viewProtocol
extension UserChatViewController: UserChatViewProtocol {
    
    // method for add data to table
    func addChannelToTable(_ channel: ChannelModel) {
        var channelEmpty = true
        channelEmpty = !channels.isEmpty ? false : true
        
        guard !self.channels.contains(channel) else { return }
        channels.append(channel)
        channels.sort()
        if !channelEmpty {
            guard let index = channels.firstIndex(of: channel) else { return }
            let indexPath = [IndexPath(row: index, section: 0)]
            tableView.insertRows(at: indexPath, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
    
    // method for update data to table
    func updateChannelInTable(_ channel: ChannelModel) {
        // mencari index dari data baru yg ada di dalam object
        guard let index = channels.firstIndex(of: channel) else { return }
        // untuk mengganti value dari spesific object di dalam array object
        channels[index] = channel
        
        // dibawah ini untuk update data baru ke spesific row or index, tanpa perlu reload table
        let indexPath = [IndexPath(row: index, section: 0)]
        tableView.reloadRows(at: indexPath, with: .automatic)
    }
    
    // method for delete data to table
    func removeChannelFromTable(_ channel: ChannelModel) {
        guard let index = channels.firstIndex(of: channel) else { return }
        channels.remove(at: index)
        if !channels.isEmpty {
            let indexPath = [IndexPath(row: index, section: 0)]
            tableView.deleteRows(at: indexPath, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }
    
}
