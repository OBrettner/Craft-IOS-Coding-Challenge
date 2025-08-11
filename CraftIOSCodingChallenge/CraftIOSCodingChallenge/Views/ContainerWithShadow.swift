import UIKit

class ContainerWithShadow: UIView {
    private var containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Constants.cornerRadiusOuther
        containerView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        super.addSubview(containerView)
    }
    
    override func addSubview(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

}
