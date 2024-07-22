//
//  SendMessageTextView.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import UIKit

class SendMessageTextView: UIView, NibMakable {
    // MARK: - Outlets
    @IBOutlet private var view: UIView!
    
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var sendMessageButton: UIButton!
    @IBOutlet private weak var sendImagesButton: UIButton!
    
    // MARK: - Properties
    var contentView: UIView? { view }
    
    static var defaultSize: CGSize { CGSize(width: UIScreen.main.bounds.width, height: 62) }
    private let minTextViewHeight: CGFloat = 20
    
    var sendMessageCompletion: ((String?) -> Void)?
    var sendFileCompletion: Completion?
    var viewHeightChangedCompletion: ((CGFloat) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Public funcs
    func setupUI() {
        bubbleView.setCornerRadius(20)
        
        messageTextView.text = nil
        messageTextView.textContainerInset = .zero
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.isScrollEnabled = false
        messageTextView.backgroundColor = .clear
        messageTextView.delegate = self
        messageTextView.textStorage.delegate = self
    }
   
    // MARK: - Private funcs
    private func updateViewHeight() {
        let emptyHeight: CGFloat = SendMessageTextView.defaultSize.height - minTextViewHeight
        let textViewHeight = estimatedTextViewHeight()
        let height = emptyHeight + textViewHeight
        viewHeightChangedCompletion?(height)
    }
    
    private func estimatedTextViewHeight() -> CGFloat {
        let possibleSize = CGSize(width: messageTextView.frame.width, height: .infinity)
        let estimatedSize = messageTextView.sizeThatFits(possibleSize)
        let tvHeight: CGFloat = [estimatedSize.height, minTextViewHeight].max() ?? 0
        return tvHeight
    }
    
    // MARK: - Action funcs
    @IBAction private func sendButtonTapped(_ sender: UIButton) {
        sendMessageCompletion?(messageTextView.text)
        messageTextView.text = nil
        updateViewHeight()
    }
    
    @IBAction private func sendFileButtonTapped(_ sender: UIButton) {
        sendFileCompletion?()
    }
}

extension SendMessageTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        updateViewHeight()
    }
}

// FIXME: delete this extension if it's not used
extension SendMessageTextView: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        placeholderLabel.isHidden = !messageTextView.text.isEmpty
//        updateViewHeight()
    }
}
