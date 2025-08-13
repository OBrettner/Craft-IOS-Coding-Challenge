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
    var settingsViewContainer = SettingsContainerView()
    
    var changeFontView = ChangeFontView()
    var changeColorView = ChangeColorView()
    var changeImageView = ChangeThumbnailImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let closeSettingsViewTapped = UITapGestureRecognizer(target: self, action: #selector(closeSubviewrequested))
        closeListenerView.addGestureRecognizer(closeSettingsViewTapped)
        
        closeButton = createBackButton()
        
        settingsViewContainer.delegate = self
        
        view.addSubview(closeListenerView)
        view.addSubview(closeButton)
        view.addSubview(settingsViewContainer)
        view.addSubview(changeFontView)
        view.addSubview(changeColorView)
        view.addSubview(changeImageView)
        
        let fontGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSettingsEditingFinished))
        fontGestureRecognizer.direction = .down
        changeFontView.addGestureRecognizer(fontGestureRecognizer)
        changeFontView.isHidden = true
        changeFontView.delegate = self
        
        let backgroundGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSettingsEditingFinished))
        backgroundGestureRecognizer.direction = .down
        changeColorView.addGestureRecognizer(backgroundGestureRecognizer)
        changeColorView.isHidden = true
        changeColorView.delegate = self
        
        let imageGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSettingsEditingFinished))
        imageGestureRecognizer.direction = .down
        changeImageView.addGestureRecognizer(imageGestureRecognizer)
        changeImageView.isHidden = true
        changeImageView.delegate = self
        
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
        changeFontView.setActiveFontDesign(active: fontDesign)
    }
    
    func setActiveColor(color: UIColor) {
        changeColorView.setColor(color: color)
    }
    
    func setImageStateActive(active: Bool) {
        settingsViewContainer.isImageSet = active
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeListenerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        closeButton.frame = CGRect(x: view.bounds.width - closeButton.bounds.width - Constants.sidePadding, y: 60, width: 70, height: 35)
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        
        settingsViewContainer.frame = getContainerCGRect()
        settingsViewContainer.layer.cornerRadius = Constants.cornerRadiusOuther
        
        changeFontView.frame = getSettingsEditorRect(height: 140)
        changeColorView.frame = getSettingsEditorRect(height: 140)
        changeImageView.frame = getSettingsEditorRect(height: 140)
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
        
        Animations.fadeOut(view: changeFontView)
        Animations.fadeOut(view: changeColorView)
        Animations.fadeOut(view: changeImageView)
    }
    
    @IBAction func handleSettingsEditingFinished(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            Animations.fadeOut(view: changeFontView)
            Animations.fadeOut(view: changeColorView)
            Animations.fadeOut(view: changeImageView)
        }
    }
}

extension ThumbnailSettingsView: SettingsContainerViewDelegate {
    func removeBackgroundImageRequested() {
        delegate?.imageViewDidUpdate(with: nil)
        settingsViewContainer.isImageSet = false
    }

    func openFontEditRequested() {
        Animations.animateIn(view: changeFontView)
    }
    
    func openBackgroundEditRequested() {
        Animations.animateIn(view: changeColorView)
    }
    
    func openImageEditRequested() {
        Animations.animateIn(view: changeImageView)
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
    func presentAlert(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func imageViewDidUpdate(with image: UIImage) {
        delegate?.imageViewDidUpdate(with: image)
        settingsViewContainer.isImageSet = true
        Animations.fadeOut(view: changeImageView)
    }
}
