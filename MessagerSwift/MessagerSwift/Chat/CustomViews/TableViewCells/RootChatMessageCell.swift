//
//  RootChatMessageCell.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import UIKit

class RootChatMessageCell: UITableViewCell, ReusableCell {
    // MARK: - Outlets
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContentView: UIView!
    
    private weak var messageView: UIView?

    // MARK: - Properties
    private var viewModel: PChatMessageViewModel?
    private var customViewConstraints: [NSLayoutConstraint]?
    
    var menuActionCompletion: ((ChatMessageActionType, PChatMessageViewModel) -> Void)?
    
    // MARK: - Override funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        bubbleView.setCornerRadius(Constants.bubbleViewCornerRadius)
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        bubbleView.addInteraction(contextMenuInteraction)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = nil
        dateLabel.text = nil
        deactivateCustomViewConstraints()
    }
    
    // MARK: - Public funcs
    func setup(with viewModel: PChatMessageViewModel) {
        self.viewModel = viewModel
        
        dateLabel.text = viewModel.dateString
        
        switch viewModel.messageType {
        case .text(let textMessage):
            messageLabel.text = textMessage
        case .images(let imagesArray):
            // TODO: showing images will be implemented later
            break
        }
    }
    
    // MARK: - Private funcs
    private func deactivateCustomViewConstraints() {
        customViewConstraints?.forEach({ $0.isActive = false })
        customViewConstraints = nil
    }
    
    private func menuElements(for actionTypes:[ChatMessageActionType]) -> [UIMenuElement] {
        let handler: UIActionHandler = { [weak self] action in
            guard let action = ChatMessageActionType(rawValue: action.identifier.rawValue),
                  let cellVm = self?.viewModel
            else { return }
            
            self?.menuActionCompletion?(action, cellVm)
        }
        
        return actionTypes.map({
            UIAction(title: $0.title,
                     image: $0.icon,
                     identifier: .init($0.rawValue),
                     attributes: $0.attribute ?? [],
                     handler: handler)
        })
    }
    
    private func setImages(_ images: [UIImage]?) {
        guard let images = images else { return }
        
        assertionFailure("owerwrite implementation to show several images")
//        let imgView = UIImageView(frame: .zero)
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        imgView.contentMode = .scaleAspectFill
//        imgView.setCornerRadius(Constants.messageImageViewCornerRadius)
//        imgView.image = image
//        messageContentView.addSubview(imgView)
//        messageImageView = imgView
//        
//        
//        let size: CGSize
//        
//        let isWide = image.size.width >= image.size.height
//        
//        let maxWidth = UIScreen.main.bounds.width - 130
//        let maxHeight = maxWidth + (maxWidth * 0.26)
//        
//        if isWide {
//            let ratio = image.size.height / image.size.width
//            let height = maxWidth * ratio
//            size = CGSize(width: maxWidth, height: height)
//        } else {
//            let ratio = image.size.width / image.size.height
//            let width = maxHeight * ratio
//            size = CGSize(width: width, height: maxHeight)
//        }
//        
//        
//        let constraints: [NSLayoutConstraint] = [
//            imgView.topAnchor.constraint(equalTo: messageContentView.topAnchor),
//            imgView.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor),
//            imgView.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor),
//            imgView.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor),
//            imgView.widthAnchor.constraint(equalToConstant: size.width),
//            imgView.heightAnchor.constraint(equalToConstant: size.height)
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
//        customViewConstraints = constraints
//        messageContentView.layoutIfNeeded()
    }
}

extension RootChatMessageCell {
    private struct Constants {
        static let bubbleViewCornerRadius: CGFloat = 12
        static let messageImageViewCornerRadius: CGFloat = 18
        static let fileBubbleViewCornerRadius: CGFloat = 10
        static let textContentViewInsets = UIEdgeInsets(top: 8, left: 20, bottom: 11, right: 20)
        static let imageContentViewInsets = UIEdgeInsets(top: 0, left: 3, bottom: 3, right: 3)
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension RootChatMessageCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let actionTypes = viewModel?.possibleMenuActionsTypes(), !actionTypes.isEmpty else { return nil }
        
        let menuElements = self.menuElements(for: actionTypes)
        let menu = UIMenu(children: menuElements)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            return menu
        })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        self.endEditing(true)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        let targetPreview = UITargetedPreview(view: bubbleView, parameters: parameters)
        return targetPreview
    }
}
