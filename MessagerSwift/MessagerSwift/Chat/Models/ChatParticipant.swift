//
//  ChatParticipant.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation
import UIKit

class ChatParticipant {
    let participantId: String
    let name: String
    let avatarImageUrl: String?
    
    init(id: String, name: String, avatarImageUrl: String) {
        self.participantId = id
        self.name = name
        self.avatarImageUrl = avatarImageUrl
    }
}

extension ChatParticipant {
    static let otherParticipant = ChatParticipant(id: UUID().uuidString, name: "Jessica", avatarImageUrl: "https://randomuser.me/api/portraits/women/73.jpg")
    static let myParticipant = ChatParticipant(id: UUID().uuidString, name: "Fernando", avatarImageUrl: "https://randomuser.me/api/portraits/men/75.jpg")
}
