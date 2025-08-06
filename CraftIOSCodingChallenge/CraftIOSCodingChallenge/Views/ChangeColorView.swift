import UIKit

protocol ChangeColorViewDelegate: AnyObject {
    func colorViewDidUpdate(_ childView: ChangeColorView, withColor color: UIColor)
}

class ChangeColorView: UIView {

    var delegate: ChangeColorViewDelegate?
    
    let buttonColors: [UIColor] = [
        .red,
        .orange,
        .blue,
        .purple,
        .green,
        .magenta
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        delegate?.colorViewDidUpdate(self, withColor: sender.backgroundColor ?? .blue)
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.spacing = 10
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .fill
        horizontalStack.distribution = .fillEqually
        horizontalStack.isUserInteractionEnabled = true
        
        for color in buttonColors {
            let redButton = createColorButton(color)
            horizontalStack.addArrangedSubview(redButton)
        }
        
        self.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
    }
    
    private func createColorButton(_ color: UIColor) -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }

}
