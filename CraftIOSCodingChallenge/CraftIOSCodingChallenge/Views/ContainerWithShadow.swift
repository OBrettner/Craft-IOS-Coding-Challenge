import UIKit

class ContainerWithShadow: UIViewController {
    private var containerView = UIView()
    
    override func viewDidLoad() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Constants.cornerRadiusOuther
        containerView.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 10.0
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        
        view.addSubview(containerView)
    }
    
    public func addSubview(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

}
