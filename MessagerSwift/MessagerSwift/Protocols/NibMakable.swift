//
//  NibMakable.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 19.07.24.
//

import Foundation
import UIKit

protocol NibMakable {
    var contentView: UIView? { get }
    
    func commonInit()
    func setupUI()
}

extension NibMakable where Self: UIView {
    func commonInit() {
        let nibName = String(describing: type(of: self))
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth] 
        self.addSubview(content)
        
        setupUI()
    }
}
