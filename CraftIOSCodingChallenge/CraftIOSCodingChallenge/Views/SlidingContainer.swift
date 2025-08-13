import UIKit

class SlidingContainer: ContainerWithShadow {
    let slidingIndicatorView = UIView()

    override func setup() {
        super.setup()
        
        slidingIndicatorView.backgroundColor = .lightGray
        
        addSubview(slidingIndicatorView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = bounds.width * 0.1
        let height = 3.0
        
        slidingIndicatorView.frame = CGRect(x: (bounds.width - width) / 2, y: 4, width: width, height: height)
        slidingIndicatorView.layer.cornerRadius = height / 2
    }
}
