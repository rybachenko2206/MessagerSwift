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
    func imagePickerDidChooseImage(_ image: UIImage)
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
        
        guard let result = results.first else { return }
        
        let provider = result.itemProvider
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { (value, error) in
                DispatchQueue.main.async { [weak self] in
                    guard let image = value as? UIImage else {
                        if let error = error {
                            self?.delegate?.imagePickerDidReceiveError(MSError(error: error))
                        } else {
                            let ccError = MSError.custom("PHPicker load image is nil without any errors.")
                            self?.delegate?.imagePickerDidReceiveError(ccError)
                        }
                        return
                    }
                    print("selected image orientation: \(image.imageOrientation)")
                    let radians = UIImage.deg2rad(360)
                    guard let rotatedImage = image.rotate(radians: radians) else {
                        let ccError = MSError.custom("rotate image error")
                        self?.delegate?.imagePickerDidReceiveError(ccError)
                        return
                    }
                    self?.delegate?.imagePickerDidChooseImage(rotatedImage)
                }
            }
            
        } else if provider.hasItemConformingToTypeIdentifier(UTType.png.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.png.identifier) { url, error in
                print("png image url: \n\(String(describing: url))")
                assertionFailure("handle this case")
            }
        } else if provider.hasItemConformingToTypeIdentifier(UTType.jpeg.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.jpeg.identifier) { url, error in
                print("jpeg image url: \n\(String(describing: url))")
                assertionFailure("handle this case")
            }
        } else {
            print("provider.registeredContentTypes: \(provider.registeredContentTypes)")
            assertionFailure("handle this case")
        }
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
