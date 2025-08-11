import UIKit

protocol ChangeColorViewDelegate: AnyObject {
    func colorViewDidUpdate(withColor color: UIColor)
}

class ChangeColorView: SlidingContainer {

    var delegate: ChangeColorViewDelegate?
    
    let buttonColors: [UIColor] = [
        .red,
        .orange,
        .blue,
        .purple,
        .green,
        .magenta
    ]
    
    var buttons = [UIButton]()
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        delegate?.colorViewDidUpdate(withColor: sender.backgroundColor ?? .blue)
    }
    
    override func setup() {
        super.setup()
        
        buttons.removeAll()
        
        for color in buttonColors {
            buttons.append(createColorButton(color))
            addSubview(buttons.last!)
        }
    }
    
    private func createColorButton(_ color: UIColor) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = color
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = (bounds.width - ((Constants.padding / 2) * Double(buttons.count - 1) + Constants.padding * 2)) / Double(buttons.count)
        var x = Constants.padding
        for button in buttons {
            button.frame = CGRect(x: x, y: Constants.padding, width: width, height: bounds.height - (Constants.padding * 2))
            x += (Constants.padding / 2) + width
            
            button.layer.cornerRadius = Constants.cornerRadiusInner
        }
    }
}
