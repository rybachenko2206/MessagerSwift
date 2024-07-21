//
//  ChatMessageActionType.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation
import UIKit

enum ChatMessageActionType: String {
    case reply, copy, saveImage, listen, edit, delete, trySendAgain, cancelSending
    
    var title: String {
        switch self {
        case .reply: return "Reply"
        case .copy: return "Copy"
        case .saveImage: return "Save Image"
        case .listen: return "Listen"
        case .edit: return "Edit"
        case .delete: return "Delete"
        case .trySendAgain: return "Try send again"
        case .cancelSending: return "Cancel Sending"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .reply: return UIImage(systemName: "arrowshape.turn.up.left")
        case .copy: return UIImage(systemName: "doc.on.doc")
        case .saveImage: return UIImage(systemName: "square.and.arrow.down")
        case .listen: return UIImage(systemName: "message.and.waveform")
        case .edit: return UIImage(systemName: "pencil")
        case .delete: return UIImage(systemName: "trash")
        case .trySendAgain: return UIImage(systemName: "paperplane")
        case .cancelSending: return UIImage(systemName: "arrow.clockwise")
        }
    }
    
    var attribute: UIMenuElement.Attributes? {
        switch self {
        case .cancelSending,
                .delete:
            return .destructive
        default:
            return nil
        }
    }
}
