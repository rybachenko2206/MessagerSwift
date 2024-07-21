//
//  ChatViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import Combine

protocol PChatViewModel {
    var tableViewInsertRowsPublisher: AnyPublisher<[IndexPath], Never> { get }
    var tableViewDeleteRowPublisher: AnyPublisher<IndexPath, Never> { get }
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func messageViewModel(for indexPath: IndexPath) -> PChatMessageViewModel?
    
    func sendNewTextMessage(_ message: String?)
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
    
    func sendNewTextMessage(_ message: String?) {
        guard let myParticipant else {
            assertionFailure()
            return
        }
        
        guard let message, !message.isBlank else { return }
        let trimmedText = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let messageType = MessageType.text(trimmedText)
        let chatMessage = ChatMessage(
            roomId: chatRoom.roomId,
            messageId: UUID().uuidString,
            sender: myParticipant,
            type: messageType
        )
        
        chatService.sendMessage(chatMessage, to: chatRoom.roomId)
        let msgViewModel = ChatMessageViewModel(message: chatMessage, myParticipantId: myParticipant.participantId)
        messageViewModels.insert(msgViewModel, at: 0)
        let ip = IndexPath(row: 0, section: 0)
        tableViewInsertRowsSubject.send([ip])
    }
    
    private func setupBinings() {
        chatService.newMessagePublisher
            .sink(receiveValue: { [weak self] newMessage in
                print("~~new message received: \n\(newMessage), date: \(newMessage.createdAt)")
            })
            .store(in: &subscriptions)
    }
}
