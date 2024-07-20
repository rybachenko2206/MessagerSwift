//
//  ChatViewModel.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation

protocol PChatViewModel {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func messageViewModel(for indexPath: IndexPath) -> PChatMessageViewModel?
}

class ChatViewModel: PChatViewModel {
    // MARK: Properties
    private let chatRoom: ChatRoom
    private var messageViewModels: [PChatMessageViewModel] = []
    
    private let chatService: PChatService
    
    // MARK: - Init
    init(chatRoom: ChatRoom, chatService: PChatService) {
        self.chatRoom = chatRoom
        self.chatService = chatService
    }
    
    // MARK: - Public funcs
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        messageViewModels.count
    }
    
    func messageViewModel(for indexPath: IndexPath) -> PChatMessageViewModel? {
        messageViewModels[safe: indexPath.row]
    }
}
