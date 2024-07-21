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
    var placeholderImage: UIImage? { get }
    var isMyMessage: Bool { get }
    
    func possibleMenuActionsTypes() -> [ChatMessageActionType]?
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
    
    let placeholderImage: UIImage? = UIImage(systemName: "person.circle.fill")
    
    
    // MARK: - Init
    init(message: ChatMessage, isMyMessage: Bool) {
        self.message = message
        self.isMyMessage = isMyMessage
    }
    
    // MARK: - Public funcs
    func possibleMenuActionsTypes() -> [ChatMessageActionType]? {
        var actionTypes: [ChatMessageActionType] = []
        
        switch messageType {
        case .text(_):
            actionTypes = [.copy, .listen]
            if isMyMessage {
                actionTypes.append(.edit)
            }
            
        case .images(_):
            actionTypes = [.saveImage]
        }
        
        if isMyMessage {
            actionTypes.append(.delete)
        } else {
            actionTypes.append(.reply)
        }
        
        return actionTypes
    }
}
