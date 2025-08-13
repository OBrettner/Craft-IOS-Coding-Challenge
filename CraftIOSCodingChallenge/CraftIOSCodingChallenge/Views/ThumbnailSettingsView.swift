import UIKit

protocol SettingsViewDelegate: AnyObject {
    func closeSettingsView()
    func fontViewDidUpdate(withDesign fontDesign: UIFontDescriptor.SystemDesign)
    func backgroundColorDidUpdate(withColor color: UIColor)
    func imageViewDidUpdate(with image: UIImage?)
}

class ThumbnailSettingsView: UIViewController {
    var delegate: SettingsViewDelegate?
    
    var closeListenerView = UIView()
    var closeButton = UIButton()
    var currentColor = UIColor.blue
    var currentFontDesign = UIFontDescriptor.SystemDesign.default
    var settingsViewContainer = SettingsContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let closeSettingsViewTapped = UITapGestureRecognizer(target: self, action: #selector(closeSubviewrequested))
        closeListenerView.addGestureRecognizer(closeSettingsViewTapped)
        
        closeButton = createBackButton()
        
        settingsViewContainer.delegate = self
        
        view.addSubview(closeListenerView)
        view.addSubview(closeButton)
        view.addSubview(settingsViewContainer.view)
        
        addChild(settingsViewContainer)
        
        view.sendSubviewToBack(closeListenerView)
    }
    
    func createBackButton() -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkText
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(closeSubviewrequested), for: .touchUpInside)
                
        return button
    }
    
    func setActiveFontDesign(fontDesign: UIFontDescriptor.SystemDesign) {
        currentFontDesign = fontDesign
    }
    
    func setActiveColor(color: UIColor) {
        currentColor = color
    }
    
    func setImageStateActive(active: Bool) {
        settingsViewContainer.isImageSet = active
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeListenerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        closeButton.frame = CGRect(x: view.bounds.width - closeButton.bounds.width - Constants.sidePadding, y: 60, width: 70, height: 35)
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        settingsViewContainer.view.frame = getContainerCGRect()
        settingsViewContainer.view.layer.cornerRadius = Constants.cornerRadiusOuther
    }
    
    func getContainerCGRect() -> CGRect {
        let width = view.bounds.width * 0.9
        let height = 80.0
        let x = (view.bounds.width - width) / 2
        let y = view.bounds.height - height - 40.0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func getSettingsEditorRect(height: CGFloat) -> CGRect {
        let width = view.bounds.width * 0.94
        let x = (view.bounds.width - width) / 2
        let y = view.bounds.height - height - 46.0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @objc func closeSubviewrequested() {
        delegate?.closeSettingsView()
        dismiss(animated: true)
    }
    
    @IBAction func handleSettingsEditingFinished(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            dismiss(animated: true)
        }
    }
}

extension ThumbnailSettingsView: SettingsContainerViewDelegate {
    func removeBackgroundImageRequested() {
        delegate?.imageViewDidUpdate(with: nil)
        settingsViewContainer.isImageSet = false
    }

    func openFontEditRequested() {
        let changeFont = ChangeFontView()
        changeFont.delegate = self
        changeFont.setActiveFontDesign(active: currentFontDesign)
        self.present(changeFont, animated: true)
    }
    
    func openBackgroundEditRequested() {
        let changeColor = ChangeColorView()
        changeColor.delegate = self
        changeColor.setColor(color: self.currentColor)
        self.present(changeColor, animated: true)
    }
    
    func openImageEditRequested() {
        let changeImage = ChangeThumbnailImageView()
        changeImage.delegate = self
        self.present(changeImage, animated: true)
    }
}

extension ThumbnailSettingsView: ChangeFontViewDelegate {
    func fontViewDidUpdate(withDesign fontDesign: UIFontDescriptor.SystemDesign) {
        delegate?.fontViewDidUpdate(withDesign: fontDesign)
    }
}

extension ThumbnailSettingsView: ChangeColorViewDelegate {
    func colorViewDidUpdate(withColor color: UIColor) {
        delegate?.backgroundColorDidUpdate(withColor: color)
    }
}

extension ThumbnailSettingsView: ChangeThumbnailImageViewDelegate {
    func imageViewDidUpdate(with image: UIImage) {
        delegate?.imageViewDidUpdate(with: image)
        settingsViewContainer.isImageSet = true
    }
}
