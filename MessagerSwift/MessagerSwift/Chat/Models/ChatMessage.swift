//
//  ChatMessage.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

enum MessageType {
    case text(String)
    case images([UIImage])
}

class ChatMessage {
    let roomId: String
    let messageId: String
    let sender: ChatParticipant
    let messageType: MessageType
    let createdAt: Date
    
    var text: String? {
        switch messageType {
        case .text(let text):
            return text
        default:
            return nil
        }
    }
    var images: [UIImage]? {
        switch messageType {
        case .images(let array):
            return array
        default:
            return nil
        }
    }
    
    init(roomId: String, messageId: String, sender: ChatParticipant, type: MessageType) {
        self.roomId = roomId
        self.messageId = messageId
        self.sender = sender
        self.messageType = type
        self.createdAt = Date()
    }
}

extension ChatMessage {
    static func fakeTextMessage(in roomId: String,  from otherParticipant: ChatParticipant) -> ChatMessage {
        let messagesArray: [String] = [
            "Hello!", "How are you?", "Isn't it a beautiful day?", "What’s new with you?", "Have you been busy lately?",
            "There’s a lot going on", "I must let you go", "It was lovely to see you", "Tell me everything!"
        ]
        
        let msgIndex: Int = Int.random(in: 1...messagesArray.count - 1)
        let textMsg = messagesArray[msgIndex]
        let msgId = UUID().uuidString
        let msgType = MessageType.text(textMsg)
        let chatMessage = ChatMessage(roomId: roomId, messageId: msgId, sender: otherParticipant, type: msgType)
        return chatMessage
    }
}
