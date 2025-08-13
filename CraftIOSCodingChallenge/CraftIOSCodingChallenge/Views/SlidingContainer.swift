import UIKit

class SlidingContainer: ContainerWithShadow {
    let slidingIndicatorView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slidingIndicatorView.backgroundColor = .lightGray
        
        addSubview(slidingIndicatorView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = view.bounds.width * 0.1
        let height = 3.0
        
        slidingIndicatorView.frame = CGRect(x: (view.bounds.width - width) / 2.0, y: 4, width: width, height: height)
        slidingIndicatorView.layer.cornerRadius = height / 2
        
        let frameWidth = view.bounds.width * 0.94
        let x = (view.bounds.width - width) / 2
        let y = view.bounds.height - height - 46.0
        
        view.frame = CGRect(x: x, y: y, width: frameWidth, height: 140)
    }
}
