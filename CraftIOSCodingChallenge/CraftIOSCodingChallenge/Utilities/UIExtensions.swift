import UIKit

extension UIStackView {
    public static func createStack(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = axis
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.isUserInteractionEnabled = true
        
        return stack
    }
}

extension UIButton {
    public static func createImageButton(image: String, label: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = createBaseButtonConfiguration()
        config.title = label
        config.image = UIImage(systemName: image)!
        if let image = config.image {
            let tintedImage = image.withTintColor(color, renderingMode: .alwaysOriginal)
            config.image = tintedImage
        }
        config.baseBackgroundColor = color.withAlphaComponent(0.05)
        button.configuration = config
        
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
