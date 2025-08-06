//
//  ChangeThumbnailImageView.swift
//  CraftIOSCodingChallenge
//
//  Created by Oliver Brettmer on 2025. 08. 06..
//

import UIKit
import Photos

protocol ChangeThumbnailImageViewDelegate: AnyObject {
    func presentAlert(_ childView: ChangeThumbnailImageView, viewControllerToPresent: UIViewController,
                      animated flag: Bool,
                      completion: (() -> Void)?)
    
    func imageViewDidUpdate(_ childView: ChangeThumbnailImageView, with image: UIImage)
}

class ChangeThumbnailImageView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate: ChangeThumbnailImageViewDelegate?
    
    let cameraRollButton = UIButton.createImageButton(image: "camera", label: "Camera Rol", color: .darkGray)
    let photoLibraryButton = UIButton.createImageButton(image: "photo.on.rectangle.angled", label: "Photo Library", color: .darkGray)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView.createStack(.horizontal)
        
        cameraRollButton.translatesAutoresizingMaskIntoConstraints = false
        photoLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(cameraRollButton)
        stackView.addArrangedSubview(photoLibraryButton)
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: 0),
            
            cameraRollButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 0),
            
            photoLibraryButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 0),
            
        ])
    }
    
    private func setupActions() {
        photoLibraryButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        cameraRollButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    @objc private func selectImageButtonTapped() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch status {
                case .authorized, .limited:
                    self.presentImagePicker()
                case .denied, .restricted:
                    self.showPermissionAlert()
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    @objc private func cameraButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.showNoCameraAlert()
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if granted {
                    self.presentCamera()
                } else {
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        delegate?.presentAlert(self, viewControllerToPresent: imagePicker, animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        delegate?.presentAlert(self, viewControllerToPresent: imagePicker, animated: true, completion: nil)
    }
    
    private func showNoCameraAlert() {
        let alert = UIAlertController(
            title: "No Camera Available",
            message: "This device does not have a camera.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        delegate?.presentAlert(self, viewControllerToPresent: alert, animated: true, completion: nil)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Photo Library Access Denied",
            message: "Please enable photo library access in your device's Settings to select images.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        delegate?.presentAlert(self, viewControllerToPresent: alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            if let takenPicture = info[.originalImage] as? UIImage {
                delegate?.imageViewDidUpdate(self, with: takenPicture)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
