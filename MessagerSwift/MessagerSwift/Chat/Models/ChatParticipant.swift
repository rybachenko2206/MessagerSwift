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
    let avatarImage: UIImage? // in real project it would be let avatarImageUrl: URL? 
    
    init(id: String, name: String, avatarImage: UIImage?) {
        self.participantId = id
        self.name = name
        self.avatarImage = avatarImage
    }
}

extension ChatParticipant {
    static let otherParticipant = ChatParticipant(id: UUID().uuidString, name: "Jessica", avatarImage: UIImage(named: "Alba"))
    static let myParticipant = ChatParticipant(id: UUID().uuidString, name: "Fernando", avatarImage: UIImage(named: "Torres"))
}
