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
    
    var fontFamily: String = "" {
        didSet {
            setNeedsLayout()
        }
    }
    
    var padding: CGFloat = 15.0 {
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
        self.layer.cornerRadius = 20
        backgroundColor = .blue
        setupLabel()
    }
    
    private func setupLabel() {
        initialsLabel = UILabel()
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.numberOfLines = 1
        initialsLabel.textAlignment = .center
        initialsLabel.adjustsFontSizeToFitWidth = false
        initialsLabel.lineBreakMode = .byClipping
        initialsLabel.textColor = .white
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(initialsLabel)
        addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            initialsLabel.topAnchor.constraint(equalTo: self.topAnchor),
            initialsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            initialsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            initialsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
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
            
            let font = UIFont(name: fontFamily, size: midPoint) ?? UIFont.systemFont(ofSize: midPoint)
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
        initialsLabel.font = UIFont(name: fontFamily, size: finalFontSize) ?? UIFont.systemFont(ofSize: finalFontSize, weight: UIFont.Weight.medium)
    }
}
