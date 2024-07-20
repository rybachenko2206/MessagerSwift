//
//  ChatService.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation
import Combine

protocol PChatService {
    var newMessagePublisher: AnyPublisher<ChatMessage, Never> { get }
    
    func sendMessage(_ message: ChatMessage, to roomId: String)
    func fetchMessages()
}

class ChatService: PChatService {
    // MARK: - Properties
    private var messageGeneratorTimer: Timer?
    private let newMessageSubject: PassthroughSubject<ChatMessage, Never> = .init()
    var newMessagePublisher: AnyPublisher<ChatMessage, Never> { newMessageSubject.eraseToAnyPublisher() }
    
    init() {
        setupFakeMessagesGenerator()
    }
    
    deinit {
        messageGeneratorTimer?.invalidate()
        messageGeneratorTimer = nil
    }
    
    // MARK: - Public funcs
    func sendMessage(_ message: ChatMessage, to roomId: String) {
        // message sends to server part with an API from here
    }
    
    func fetchMessages() {
        
    }
    
    // MARK: - Private funcs
    private func setupFakeMessagesGenerator() {
        var nextMessageDate: Date?
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            if nextMessageDate == nil {
                let randSeconds = TimeInterval(Int.random(in: 1..<8))
                nextMessageDate = Date().addingTimeInterval(randSeconds)
            }
            
            if let nextDate = nextMessageDate, Date() >= nextDate {
                let newMsg = ChatMessage.fakeTextMessage(in: ChatRoom.testRoom.roomId, from: ChatParticipant.otherParticipant)
                self?.newMessageSubject.send(newMsg)
                nextMessageDate = nil
            }
        }
    }
}
