//
//  ImagePickerManager.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation
import UIKit
import PhotosUI

protocol ImagePickerManagerDelegate: AnyObject {
    func imagePickerDidChooseImages(_ images: [UIImage])
    func imagePickerDidChooseVideo(at url: URL)
    func imagePickerDidReceiveError(_ error: Error)
}

extension ImagePickerManagerDelegate {
    func imagePickerDidReceiveError(_ error: Error) { }
    func imagePickerDidChooseVideo(at url: URL) { }
}

class ImagePickerManager: NSObject {
    // MARK: - Properties
    private lazy var phPicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .any(of: [.images, .livePhotos, .screenshots])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
    weak var delegate: ImagePickerManagerDelegate?
    
    private weak var viewController: UIViewController?
    
    // MARK: - Public funcs
    func addPHPicker(to viewController: UIViewController) {
        self.viewController = viewController
        self.viewController?.present(phPicker, animated: true, completion: nil)
    }

}

// MARK: - PHPickerViewControllerDelegate
extension ImagePickerManager: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProviders = results.map({ $0.itemProvider })
        
        let dispatchGroup: DispatchGroup = DispatchGroup()
        var selectedImages: [UIImage] = []
        
        for provider in itemProviders {
            dispatchGroup.enter()
            provider.loadObject(ofClass: UIImage.self) { (value, error) in
                if let image = value as? UIImage {
                    // here could be problems with incorrect image orientation
                    // it doesn't needed for testing using iPhone simulator
                    // but it's helpful for images from real device gallery.
                    print("selected image orientation: \(image.imageOrientation)")
                    let radians = UIImage.deg2rad(360)
                    if let rotatedImage = image.rotate(radians: radians) {
                        selectedImages.append(rotatedImage)
                    }
                    
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            self?.delegate?.imagePickerDidChooseImages(selectedImages)
        })
    }
}

enum MSError: Error, LocalizedError {
    case custom(String)
    case defaultError
    
    init(error: Error) {
        self = .custom(error.localizedDescription)
    }
    
    var localizedDescription: String {
        switch self {
        case .custom(let message):
            return message
        case .defaultError:
            return "Something went wrong. Try again later"
        }
    }
}
