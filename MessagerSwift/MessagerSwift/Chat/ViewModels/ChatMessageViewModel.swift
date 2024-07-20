//
//  ChatMessageViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation

protocol PChatMessageViewModel {
    var messageId: String { get }
}

class ChatMessageViewModel: PChatMessageViewModel {
    // MARK: - Properties
    private let message: ChatMessage
    private let myParticipantId: String
    
    var messageId: String { message.messageId }
    
    // MARK: - Init
    init(message: ChatMessage, myParticipantId: String) {
        self.myParticipantId = myParticipantId
        self.message = message
    }
}
