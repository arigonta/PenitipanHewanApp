//
//  ChatDetailViewController.swift
//  PenitipanHewanApp
//
//  Created by Marco Ramadhani (ID) on 15/08/20.
//  Copyright © 2020 JOJA. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView

protocol ChatDetailViewProtocol {
    func insertMessage(_ message: Message)
    func deleteMessage(_ message: Message)
    func successSendMessage()
}

class ChatDetailViewController: MessagesViewController {
    
    public var channelModel: ChannelModel?
    private var currentUsername: String = UserDefaultsUtils.shared.getUsername()
    private var role: String = UserDefaultsUtils.shared.getRole()
    private var messages: [Message] = []
    private var presenter: ChatDetailPresenterProtocol?
    
    init(_ channelModel: ChannelModel?) {
        self.channelModel = channelModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChatDetailPresenter(self, channelModel)
        setView()
        presenter?.messageListnerObserv(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.removeListener()
    }
    
    func setView() {
        self.navigationController?.navigationBar.tintColor = .white
        self.title = role.elementsEqual("customer") ? channelModel?.petshopId ?? "" : channelModel?.customerId ?? ""
        
        // set input bar
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = ColorHelper.instance.mainGreen
        messageInputBar.inputTextView.layer.borderColor = ColorHelper.instance.mainGreen.cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1
        messageInputBar.inputTextView.layer.cornerRadius = 8
        messageInputBar.sendButton.setTitleColor(ColorHelper.instance.mainGreen, for: .normal)
        
        // set delegate
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            // make hide avatar current user
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            // make hide avatar sender
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.setMessageIncomingAvatarSize(.zero)
            
            // set alignemt and padding bottom label message for curent user
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right,
                                                                                textInsets: .init(top: 0,
                                                                                                  left: 0,
                                                                                                  bottom: 0,
                                                                                                  right: 10)))
            // set alignemt and padding bottom label message for sender
            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left,
                                                                                textInsets: .init(top: 0,
                                                                                                  left: 10,
                                                                                                  bottom: 0,
                                                                                                  right: 0)))
        }
    }
}

// MARK: - MessagesCellDelegate
extension ChatDetailViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        self.messageInputBar.inputTextView.resignFirstResponder()
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatDetailViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? ColorHelper.instance.mainGreen : ColorHelper.black
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatDetailViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

// MARK: - MessagesDataSource
extension ChatDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return SenderModel(currentUsername, currentUsername)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: CommonHelper.shared.dateToString(from: message.sentDate),
                                  attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                               NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
}

// MARK: - MessageInputBarDelegate
extension ChatDetailViewController: InputBarAccessoryViewDelegate {
    
    // when user click send
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(currentUserName: currentUsername, content: text, displayName: currentUsername)
        presenter?.save(self, message)
        inputBar.inputTextView.text = ""
    }
    
}

// MARK: - ViewPresenter
extension ChatDetailViewController: ChatDetailViewProtocol {
    func insertMessage(_ message: Message) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
//        let shouldScrollToBottom = messagesCollectionView.positio && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        dispatchMainAsync {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func deleteMessage(_ message: Message) {
        guard let index = messages.firstIndex(of: message) else { return }
        messages.remove(at: index)
        let indexPath = [IndexPath(row: index, section: 0)]
        messagesCollectionView.deleteItems(at: indexPath)
    }
    
    func successSendMessage() {
        self.messagesCollectionView.scrollToBottom()
    }
}
