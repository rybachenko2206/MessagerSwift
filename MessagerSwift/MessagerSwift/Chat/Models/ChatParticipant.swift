//
//  ChatParticipant.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation
import UIKit

class ChatParticipant {
    let name: String
    let avatarImage: UIImage? // in real project it would be let avatarImageUrl: URL? 
    
    init(name: String, avatarImage: UIImage?) {
        self.name = name
        self.avatarImage = avatarImage
    }
}

extension ChatParticipant {
    static let otherParticipant = ChatParticipant(name: "Jessica", avatarImage: UIImage(named: "Alba"))
    static let myParticipant = ChatParticipant(name: "Fernando", avatarImage: UIImage(named: "Torres"))
}
