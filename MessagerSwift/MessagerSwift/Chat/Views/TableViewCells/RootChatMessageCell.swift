//
//  RootChatMessageCell.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import UIKit

class RootChatMessageCell: UITableViewCell, ReusableCell {
    // MARK: - Outlets
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var messageContentView: UIView!
    
    @IBOutlet private weak var msgContentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var msgContentViewRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var msgContentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var msgContentViewLeftConstraint: NSLayoutConstraint!
    
    private weak var messageView: UIView?
    private weak var carouselView: ImagesCarouselView?
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
        carouselView?.removeFromSuperview()
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
            messageLabel.text = nil
            setImages(imagesArray)
        }
        
        updateContentViewEdgeConstraints(for: viewModel.messageType)
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
        guard let carouselViewModel = viewModel?.carouselImageView else { return }
        
        let carouselView = ImagesCarouselView(frame: .zero)
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        carouselView.setCornerRadius(Constants.imagesCarouselViewCornerRadius)
        carouselView.setup(with: carouselViewModel)
        messageContentView.addSubview(carouselView)
        self.carouselView = carouselView
        
        let width = UIScreen.main.bounds.width - 140
        let height = width * 0.75
        let size = CGSize(width: width, height: height)
        
        let constraints: [NSLayoutConstraint] = [
            carouselView.topAnchor.constraint(equalTo: messageContentView.topAnchor),
            carouselView.trailingAnchor.constraint(equalTo: messageContentView.trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: messageContentView.bottomAnchor),
            carouselView.leadingAnchor.constraint(equalTo: messageContentView.leadingAnchor),
            carouselView.widthAnchor.constraint(equalToConstant: size.width),
            carouselView.heightAnchor.constraint(equalToConstant: size.height)
        ]
        
        NSLayoutConstraint.activate(constraints)
        customViewConstraints = constraints
        messageContentView.layoutIfNeeded()
    }
    
    private func updateContentViewEdgeConstraints(for messageType: MessageType) {
        let insets: UIEdgeInsets
        
        switch messageType {
        case .text:
            insets = Constants.textContentViewInsets
        case .images:
            insets = Constants.imageContentViewInsets
        }
        
        msgContentViewTopConstraint.constant = insets.top
        msgContentViewRightConstraint.constant = insets.right
        msgContentViewBottomConstraint.constant = insets.bottom
        msgContentViewLeftConstraint.constant = insets.left
    }
}

extension RootChatMessageCell {
    private struct Constants {
        static let bubbleViewCornerRadius: CGFloat = 12
        static let imagesCarouselViewCornerRadius: CGFloat = 10.5
        static let fileBubbleViewCornerRadius: CGFloat = 10
        static let textContentViewInsets = UIEdgeInsets(top: 8, left: 20, bottom: 11, right: 20)
        static let imageContentViewInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
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
