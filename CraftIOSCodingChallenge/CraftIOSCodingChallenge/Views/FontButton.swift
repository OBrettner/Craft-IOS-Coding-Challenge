import UIKit

class FontButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init(_ title: String, font: UIFont?) {
        self.init(frame: .zero)
        setup()
        setConfig(title, font: font)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
    }
    
    public func setConfig(_ title: String, font: UIFont?) {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .gray.withAlphaComponent(0.1)
        config.baseForegroundColor = .label
        let customFont: UIFont
        
        customFont = font ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let attributes: [NSAttributedString.Key: Any] = [
                   .font: customFont
               ]
               
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        config.attributedTitle = AttributedString(attributedTitle)
        config.cornerStyle = .medium
        self.configuration = config
    }

}
