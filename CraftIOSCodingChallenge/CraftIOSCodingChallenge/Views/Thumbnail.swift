import UIKit

class ThumbnailView: UIView {
    var initialsLabel: UILabel!
    
    var text: String? {
        didSet {
            initialsLabel.text = text
            setNeedsLayout()
        }
    }
    
    var thumbnailImage: UIImage? {
        didSet {
            setImage()
        }
    }
    
    let backgroundImageView = UIImageView()
    
    var fontDesign: UIFontDescriptor.SystemDesign = .default {
        didSet {
            setNeedsLayout()
        }
    }
    
    var padding: CGFloat = Constants.padding {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = Constants.cornerRadiusOuther
        backgroundColor = .blue
        setupLabel()
    }
    
    private func setupLabel() {
        initialsLabel = UILabel()
        initialsLabel.numberOfLines = 1
        initialsLabel.textAlignment = .center
        initialsLabel.adjustsFontSizeToFitWidth = false
        initialsLabel.lineBreakMode = .byClipping
        initialsLabel.textColor = .white
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        
        addSubview(initialsLabel)
        addSubview(backgroundImageView)
        
        self.sendSubviewToBack(backgroundImageView)
    }
    
    private func setImage() {
        backgroundImageView.image = thumbnailImage
        if thumbnailImage != nil {
            bringSubviewToFront(backgroundImageView)
        } else {
            sendSubviewToBack(backgroundImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        initialsLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        guard let text = initialsLabel.text, !text.isEmpty, bounds.width > 0, bounds.height > 0 else {
            initialsLabel.font = UIFont.systemFont(ofSize: 1.0)
            return
        }
        
        let availableRect = bounds.insetBy(dx: padding, dy: padding)
        let availableWidth = availableRect.width
        let availableHeight = availableRect.height
        
        guard availableWidth > 0, availableHeight > 0 else {
            initialsLabel.font = UIFont.systemFont(ofSize: 1.0)
            return
        }
        
        var lowerBound: CGFloat = 1.0
        var upperBound = availableHeight
        
        for _ in 0..<100 {
            let midPoint = (lowerBound + upperBound) / 2.0
            
            if (upperBound - lowerBound) < 0.1 {
                break
            }
            
            var font = UIFont.systemFont(ofSize: midPoint)
            
            let baseFont = UIFont.systemFont(ofSize: midPoint, weight: .semibold)
            if let fontDescriptor = baseFont.fontDescriptor.withDesign(fontDesign) {
                let newFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
                font = newFont
            } else {
                font = baseFont
            }
            
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            
            let targetSize = CGSize(width: availableWidth, height: availableHeight)
            
            let textSize = (text as NSString).boundingRect(
                with: targetSize,
                options: [.usesLineFragmentOrigin],
                attributes: attributes,
                context: nil
            )
            
            if textSize.width <= availableWidth && textSize.height <= availableHeight {
                lowerBound = midPoint
            } else {
                upperBound = midPoint
            }
        }
        
        let finalFontSize = lowerBound
        let baseFont = UIFont.systemFont(ofSize: finalFontSize, weight: .semibold)
        if let fontDescriptor = baseFont.fontDescriptor.withDesign(fontDesign) {
            let newFont = UIFont(descriptor: fontDescriptor, size: baseFont.pointSize)
            initialsLabel.font = newFont
        } else {
            initialsLabel.font = baseFont
        }
    }
}
