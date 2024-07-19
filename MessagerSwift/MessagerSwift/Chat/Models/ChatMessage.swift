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
    let sender: ChatParticipant
    let messageType: MessageType
    
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
    
    init(sender: ChatParticipant, text: String?, type: MessageType) {
        self.sender = sender
        self.messageType = type
    }
}


class ChatParticipant {
    let name: String
    let avatarImage: UIImage?
    
    init(name: String, avatarImage: UIImage?) {
        self.name = name
        self.avatarImage = avatarImage
    }
}
