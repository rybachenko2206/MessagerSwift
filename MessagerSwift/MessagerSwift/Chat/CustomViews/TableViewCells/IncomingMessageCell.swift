//
//  IncomingMessageCell.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import UIKit

class IncomingMessageCell: RootChatMessageCell {
    // MARK: - Outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    // MARK: - Overriden funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.setCornerRadius(avatarImageView.frame.width / 2)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
    }
    
    // MARK: - Public funcs
    override func setup(with viewModel: PChatMessageViewModel) {
        super.setup(with: viewModel)
        
        avatarImageView.image = viewModel.senderAvatarImage
    }
}
