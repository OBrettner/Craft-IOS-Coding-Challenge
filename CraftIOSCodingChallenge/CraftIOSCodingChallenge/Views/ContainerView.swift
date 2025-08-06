import UIKit

class ContainerView: UIView {
    private var containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        containerView.layer.cornerRadius = 20.0
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
    }
    
    func addSubviewToContainer(_ view: UIView) {
        containerView.addSubview(view)
    }
    
    public static func createPopupView(height: CGFloat, parent parentView: UIView) -> ContainerView {
        let containerView = ContainerView()
        
        let swipeDecorationView = UIView()
        swipeDecorationView.translatesAutoresizingMaskIntoConstraints = false
        swipeDecorationView.backgroundColor = .lightGray
        swipeDecorationView.layer.cornerRadius = 4
        
        containerView.addSubviewToContainer(swipeDecorationView)
        
        parentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: height),
            
            swipeDecorationView.heightAnchor.constraint(equalToConstant: 6),
            swipeDecorationView.widthAnchor.constraint(equalToConstant: 200),
            swipeDecorationView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            swipeDecorationView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10)
        ])
        
        return containerView
    }
}
