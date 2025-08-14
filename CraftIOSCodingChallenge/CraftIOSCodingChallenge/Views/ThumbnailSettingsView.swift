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
    
    private var initialCenter = CGPoint()
    
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
        
        let fontGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleFontPanned))
        changeFontView.addGestureRecognizer(fontGestureRecognizer)
        changeFontView.isHidden = true
        changeFontView.delegate = self
        
        let backgroundGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleColorPanned))
        changeColorView.addGestureRecognizer(backgroundGestureRecognizer)
        changeColorView.isHidden = true
        changeColorView.delegate = self
        
        let imageGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleImagePanned))
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
    
    @objc func handleFontPanned(_ gesture: UIPanGestureRecognizer) {
        handlePanGestureForView(gesture, view: changeFontView)
    }
    
    @objc func handleColorPanned(_ gesture: UIPanGestureRecognizer) {
        handlePanGestureForView(gesture, view: changeColorView)
    }
    
    @objc func handleImagePanned(_ gesture: UIPanGestureRecognizer) {
        handlePanGestureForView(gesture, view: changeImageView)
    }
    
    func handlePanGestureForView(_ gesture: UIPanGestureRecognizer, view: UIView) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .began:
            initialCenter = view.center
            
        case .changed:
            var newCenterY = CGFloat()
            var alpha = CGFloat()
            let maxDismissalDistance: CGFloat = 100
            let percentageDragged = min(1, abs(translation.y) / maxDismissalDistance)
            if translation.y > 0{
                newCenterY = initialCenter.y + translation.y
                alpha = 1 - percentageDragged
                
            } else {
                newCenterY = initialCenter.y + (translation.y * (percentageDragged/3))
                alpha = 1
            }
            
            view.center = CGPoint(x: initialCenter.x, y: newCenterY)
            view.alpha = alpha
            
        case .ended:
            let velocity = gesture.velocity(in: view)
            let shouldDismiss = velocity.y > 1000 || translation.y > 50
            
            if shouldDismiss {
                UIView.animate(withDuration: 0.1, animations: {
                    view.center.y = self.view.frame.height
                    view.alpha = 0
                }) { _ in
                    view.isHidden = true
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    view.center = self.initialCenter
                    view.alpha = 1
                }
            }
            
        default:
            break
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
