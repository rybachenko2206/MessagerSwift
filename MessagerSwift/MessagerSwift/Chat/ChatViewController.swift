//
//  ViewController.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import UIKit
import Combine

class ChatViewController: UIViewController, Storyboardable {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextView: SendMessageTextView!
    @IBOutlet private weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageTextViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    static var storyboardName: Storyboard = .main
    var viewModel: PChatViewModel!

    // MARK: - Override funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNotificationObservers()
        setupBindings()
    }

    // MARK: - Private funcs
    private func setupUI() {
        title = "Chat"
        setupTableView()
        setupMessageTextView()
    }
    
    private func setupMessageTextView() {
        messageTextView.sendMessageCompletion = { [weak self] message in
            self?.viewModel.sendNewTextMessage(message)
        }
        
        messageTextView.viewHeightChangedCompletion = { [weak self] height in
            self?.messageTextViewHeightConstraint.constant = height
        }
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 0.1
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.dataSource = self
        
        // added for hiding keyboard by tap on screen
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tableView.addGestureRecognizer(tapGR)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupBindings() {
        viewModel.tableViewInsertRowsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] indexPaths in
                self?.insertRows(at: indexPaths)
            })
            .store(in: &subscriptions)
        
        viewModel.tableViewDeleteRowPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] indexPath in
                self?.deleteRow(at: indexPath)
            })
            .store(in: &subscriptions)
    }
    
    private func insertRows(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
        
        if let lastIP = indexPaths.last {
            tableView.scrollToRow(at: lastIP, at: .bottom, animated: true)
        }
    }
    
    private func deleteRow(at indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    // MARK: - Notification Observers
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveLinear.rawValue
        let options = UIView.AnimationOptions(rawValue: curve)
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        
        let keyboardHeight: CGFloat = targetFrame.height
        let bottomInset: CGFloat = UIDevice.current.bottomSafeAreaInset()
        let calcHeight = keyboardHeight - bottomInset
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            self?.messageTextViewBottomConstraint.constant = calcHeight
            self?.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveLinear.rawValue
        let options = UIView.AnimationOptions(rawValue: curve)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            self?.messageTextViewBottomConstraint.constant = 0
            self?.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Actions
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let messageVM = viewModel.messageViewModel(for: indexPath) else { return UITableViewCell() }
        
        return UITableViewCell()
    }
    
    
}
