import UIKit
import Photos

protocol ChangeThumbnailImageViewDelegate: AnyObject {
    func imageViewDidUpdate(with image: UIImage)
}

class ChangeThumbnailImageView: SlidingContainer, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: ChangeThumbnailImageViewDelegate?
    
    let cameraRollButton = UIButton.createImageButton(image: "camera", label: "Camera Rol", color: .darkGray)
    let photoLibraryButton = UIButton.createImageButton(image: "photo.on.rectangle.angled", label: "Photo Library", color: .darkGray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubview(cameraRollButton)
        addSubview(photoLibraryButton)
        
        photoLibraryButton.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
        cameraRollButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = (view.bounds.width - (2 * Constants.padding + Constants.padding / 2)) / 2
        let height = view.bounds.height - Constants.padding * 2
        
        cameraRollButton.frame = CGRect(x: Constants.padding, y: Constants.padding, width: width, height: height)
        photoLibraryButton.frame = CGRect(x: width + Constants.padding * 1.5, y: Constants.padding, width: width, height:  height)
        
        cameraRollButton.layer.cornerRadius = Constants.cornerRadiusInner
        photoLibraryButton.layer.cornerRadius = Constants.cornerRadiusInner
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
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func showNoCameraAlert() {
        let alert = UIAlertController(
            title: "No Camera Available",
            message: "This device does not have a camera.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            if let takenPicture = info[.originalImage] as? UIImage {
                self.delegate?.imageViewDidUpdate(with: takenPicture)
                dismiss(animated: true)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
