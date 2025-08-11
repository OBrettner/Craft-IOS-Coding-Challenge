import UIKit

extension UIButton {
    public static func createStyledTextButton(label: String, design: UIFontDescriptor.SystemDesign) -> UIButton {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        
        config.title = label
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            
            let baseFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
            if let fontDescriptor = baseFont.fontDescriptor.withDesign(design) {
                let newFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
                outgoing.font = newFont
            } else {
                outgoing.font = baseFont
            }
            
            return outgoing
        }
        
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .label
        
        button.configuration = config
        
        button.clipsToBounds = true
        
        button.addAction(UIAction(handler: { action in
            UIView.animate(withDuration: 0.1, animations: {
                let pressedButton = action.sender as! UIButton
                pressedButton.setSelected()
            })
        }), for: .touchDown)
        
        button.addAction(UIAction(handler: { action in
            UIView.animate(withDuration: 0.1, animations: {
                let pressedButton = action.sender as! UIButton
                pressedButton.setNotSelected()
            })
        }), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        return button
    }
    
    public func setSelected() {
        self.layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15).cgColor
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2.0
    }
    
    public func setNotSelected() {
        self.layer.backgroundColor = UIColor.systemGray5.cgColor
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0.0
    }
    
    public static func createImageButton(image: String, label: String, color: UIColor) -> UIButton {
        let button = UIButton()
        
        button.clipsToBounds = true
       
        var config = createBaseButtonConfiguration()
        config.title = label
        
        if let iconImage = UIImage(systemName: image) {
            let tintedImage = iconImage.withTintColor(color, renderingMode: .alwaysOriginal)
            config.image = tintedImage
        }
        
        config.baseBackgroundColor = color.withAlphaComponent(0.05)
        button.configuration = config
        
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.05, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
                button.alpha = button.isHighlighted ? 0.5 : 1.0
            }
        }, for: .touchDown)
        button.addAction(UIAction { _ in
            UIView.animate(withDuration: 0.05, delay: 0.01, options: [.beginFromCurrentState, .allowUserInteraction]) {
                button.alpha = 1.0
            }
        }, for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    private static func createBaseButtonConfiguration() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .secondaryLabel
        config.imagePadding = 8
        config.imagePlacement = .top
        return config
    }
}
