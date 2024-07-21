//
//  ChatMessageViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation
import UIKit

protocol PChatMessageViewModel {
    var messageId: String { get }
    var dateString: String? { get }
    var messageType: MessageType { get }
    var senderAvatarImage: UIImage? { get }
    var isMyMessage: Bool { get }
}

class ChatMessageViewModel: PChatMessageViewModel {
    // MARK: - Properties
    private let message: ChatMessage
    private let myParticipantId: String
    
    var messageId: String { message.messageId }
    var dateString: String? { message.createdAt.displayDateString1() }
    var messageType: MessageType { message.messageType }
    var senderAvatarImage: UIImage? { message.sender.avatarImage }
    lazy var isMyMessage: Bool = { message.sender.participantId == myParticipantId }()
    
    
    // MARK: - Init
    init(message: ChatMessage, myParticipantId: String) {
        self.myParticipantId = myParticipantId
        self.message = message
    }
}
