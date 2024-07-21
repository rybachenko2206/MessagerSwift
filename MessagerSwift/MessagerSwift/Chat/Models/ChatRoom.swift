//
//  ChatRoom.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation

class ChatRoom {
    let roomId: String
    let participants: [ChatParticipant]
    // it's remote data model, not local, so I suggest messages property is not needed here.
    // In real project, we could have various work logic. For example, different requests to webSocket to fetch rooms, roomParticipants for the room, messages for the room with roomId etc.
    
    init(roomId: String, participants: [ChatParticipant]) {
        self.roomId = roomId
        self.participants = participants
    }
}

extension ChatRoom {
    static let testRoom: ChatRoom = {
        let participants: [ChatParticipant] = [
            ChatParticipant.myParticipant,
            ChatParticipant.otherParticipant
        ]
        return ChatRoom(roomId: UUID().uuidString, participants: participants)
    }()
}
