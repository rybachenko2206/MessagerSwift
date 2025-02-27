//
//  ChatViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit
import Combine

protocol PChatViewModel {
    var tableViewInsertRowsPublisher: AnyPublisher<[IndexPath], Never> { get }
    var tableViewDeleteRowPublisher: AnyPublisher<IndexPath, Never> { get }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func messageViewModel(for indexPath: IndexPath) -> PChatMessageViewModel?
    
    func sendNewMessage(_ messageType: MessageType)
    func deleteOutgoingMessage(_ messageViewModel: PChatMessageViewModel)
}

class ChatViewModel: PChatViewModel {
    // MARK: Properties
    private let chatService: PChatService
    private let chatRoom: ChatRoom
    
    private var messageViewModels: [PChatMessageViewModel] = []
    private var subscriptions: Set<AnyCancellable> =  []
    
    // in real project myUserId would be taken from authorization data
    private var myUserId: String { ChatParticipant.myParticipant.participantId }
    
    // myParticipant should be found using myUserId
    // if not found - the room would not be shown for current user or there is a critical bag
    private lazy var myParticipant: ChatParticipant? = {
        chatRoom.participants.first(where: { $0.participantId == myUserId })
    }()
    
    private let tableViewInsertRowsSubject: PassthroughSubject<[IndexPath], Never> = .init()
    var tableViewInsertRowsPublisher: AnyPublisher<[IndexPath], Never> {
        tableViewInsertRowsSubject.eraseToAnyPublisher()
    }
    
    private let tableViewDeleteRowSubject: PassthroughSubject<IndexPath, Never> = .init()
    var tableViewDeleteRowPublisher: AnyPublisher<IndexPath, Never> {
        tableViewDeleteRowSubject.eraseToAnyPublisher()
    }
    
    
    // MARK: - Init
    init(chatRoom: ChatRoom, chatService: PChatService) {
        self.chatRoom = chatRoom
        self.chatService = chatService
        
        setupBinings()
    }
    
    // MARK: - Public funcs
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        messageViewModels.count
    }
    
    func messageViewModel(for indexPath: IndexPath) -> PChatMessageViewModel? {
        messageViewModels[safe: indexPath.row]
    }
    
    func sendNewMessage(_ messageType: MessageType) {
        guard let myParticipant else {
            assertionFailure()
            return
        }
        
        let chatMessage = ChatMessage(
            roomId: chatRoom.roomId,
            messageId: UUID().uuidString,
            sender: myParticipant,
            type: messageType
        )
        
        chatService.sendMessage(chatMessage, to: chatRoom.roomId)
    }
    
    func deleteOutgoingMessage(_ messageViewModel: PChatMessageViewModel) {
        guard let index = messageViewModels.firstIndex(where: { $0.messageId == messageViewModel.messageId })
        else { return }
        
        messageViewModels.remove(at: index)
        let ipToDelete = IndexPath(row: index, section: 0)
        tableViewDeleteRowSubject.send(ipToDelete)
    }
    
    // MARK: - Private funcs
    private func setupBinings() {
        chatService.newMessagePublisher
            .sink(receiveValue: { [weak self] newMessage in
                self?.handleNewMessageReceived(newMessage)
            })
            .store(in: &subscriptions)
    }
    
    private func handleNewMessageReceived(_ newMessage: ChatMessage) {
        guard !messageViewModels.contains(where: { $0.messageId == newMessage.messageId }) else { return }
        guard newMessage.roomId == chatRoom.roomId else { return }
        
        let isMyMessage = newMessage.sender.participantId == myUserId
        let msgViewModel = ChatMessageViewModel(message: newMessage, isMyMessage: isMyMessage)
        messageViewModels.insert(msgViewModel, at: 0)
        let ip = IndexPath(row: 0, section: 0)
        tableViewInsertRowsSubject.send([ip])
    }
}
