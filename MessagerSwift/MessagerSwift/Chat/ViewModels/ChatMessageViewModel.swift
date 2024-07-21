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
    var senderAvatarImageUrl: URL? { get }
    var isMyMessage: Bool { get }
}

class ChatMessageViewModel: PChatMessageViewModel {
    // MARK: - Properties
    private let message: ChatMessage
    
    let isMyMessage: Bool
    
    var messageId: String { message.messageId }
    var dateString: String? { message.createdAt.displayDateString1() }
    var messageType: MessageType { message.messageType }
    var senderAvatarImageUrl: URL? {
        guard let urlString = message.sender.avatarImageUrl else { return nil }
        return URL(string: urlString)
    }
    
    
    // MARK: - Init
    init(message: ChatMessage, isMyMessage: Bool) {
        self.message = message
        self.isMyMessage = isMyMessage
    }
}
