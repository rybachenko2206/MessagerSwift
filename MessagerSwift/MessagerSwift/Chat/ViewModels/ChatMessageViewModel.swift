//
//  ChatMessageViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 20.07.24.
//

import Foundation

protocol PChatMessageViewModel {
    
}

class ChatMessageViewModel: PChatMessageViewModel {
    // MARK: - Properties
    private let message: ChatMessage
    
    // MARK: - Init
    init(message: ChatMessage) {
        self.message = message
    }
}
