import UIKit

protocol SettingsContainerViewDelegate: AnyObject {
    func openFontEditRequested()
    func openBackgroundEditRequested()
    func openImageEditRequested()
    func removeBackgroundImageRequested()
}

class SettingsContainerView: ContainerWithShadow {
    var delegate: SettingsContainerViewDelegate?
    
    let editFontButton = UIButton.createImageButton(image: "textformat", label: "Font", color: .purple)
    let editBackgroundButton = UIButton.createImageButton(image: "paintbrush", label: "Color", color: .blue)
    let editImageButton = UIButton.createImageButton(image: "photo", label: "Image", color: .orange)
    let removeImageButton = UIButton.createImageButton(image: "trash", label: "Remove", color: .red)
    
    var isImageSet = false {
        didSet {
            reflectImageState()
            setNeedsLayout()
        }
    }

    override func setup() {
        super.setup()
        
        let openFontEditingPanel = UITapGestureRecognizer(target: self, action: #selector(openFontEditingPanel))
        editFontButton.addGestureRecognizer(openFontEditingPanel)
        
        let openBackgroundEditingPanel = UITapGestureRecognizer(target: self, action: #selector(openBackgroundEditingPanel))
        editBackgroundButton.addGestureRecognizer(openBackgroundEditingPanel)
        
        let openImageEditingPanel = UITapGestureRecognizer(target: self, action: #selector(openImageEditingPanel))
        editImageButton.addGestureRecognizer(openImageEditingPanel)
        
        let removeImage = UITapGestureRecognizer(target: self, action: #selector(removeImage))
        removeImageButton.addGestureRecognizer(removeImage)
        
        addSubview(editFontButton)
        addSubview(editBackgroundButton)
        addSubview(editImageButton)
        addSubview(removeImageButton)
        
        reflectImageState()
    }
    
    func reflectImageState() {
        if (isImageSet) {
            removeImageButton.isHidden = false
            editFontButton.isHidden = true
            editBackgroundButton.isHidden = true
        } else {
            removeImageButton.isHidden = true
            editFontButton.isHidden = false
            editBackgroundButton.isHidden = false
        }
    }
    
    @objc func openFontEditingPanel() {
        delegate?.openFontEditRequested()
    }
    
    @objc func openBackgroundEditingPanel() {
        delegate?.openBackgroundEditRequested()
    }
    
    @objc func openImageEditingPanel() {
        delegate?.openImageEditRequested()
    }
    
    @objc func removeImage() {
        delegate?.removeBackgroundImageRequested()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = bounds.height - 24
        
        if(isImageSet) {
            let width = (bounds.width - (12 * 3)) / 2
            editImageButton.frame = CGRect(x: 12, y: 12, width: width, height: height)
            removeImageButton.frame = CGRect(x: (12*2) + width, y: 12, width: width, height: height)
        } else {
            let width = (bounds.width - (12 * 4)) / 3
            editFontButton.frame = CGRect(x: 12, y: 12, width: width, height: height)
            editBackgroundButton.frame = CGRect(x: (12*2) + width, y: 12, width: width, height: height)
            editImageButton.frame = CGRect(x: (12*3) + (width*2), y: 12, width: width, height: height)
        }
        
        editFontButton.layer.cornerRadius = Constants.cornerRadiusInner
        editBackgroundButton.layer.cornerRadius = Constants.cornerRadiusInner
        editImageButton.layer.cornerRadius = Constants.cornerRadiusInner
        removeImageButton.layer.cornerRadius = Constants.cornerRadiusInner
    }
}
