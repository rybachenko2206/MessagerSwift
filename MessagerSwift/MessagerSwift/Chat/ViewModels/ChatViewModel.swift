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
    func messageItem(for indexPath: IndexPath) -> ChatMessage?
}

class ChatViewModel: PChatViewModel {
    // MARK: Properties
    private var messages: [ChatMessage] = []
    
    // MARK: - Public funcs
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        messages.count
    }
    
    func messageItem(for indexPath: IndexPath) -> ChatMessage? {
        messages[safe: indexPath.row]
    }
}
