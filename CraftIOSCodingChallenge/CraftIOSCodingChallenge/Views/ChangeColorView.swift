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
        .green
    ]
    
    var buttons = [UIButton]()
    
    let colorWell = UIColorWell()
    
    override func setup() {
        super.setup()
        
        buttons.removeAll()
        
        colorWell.selectedColor = .blue
        colorWell.supportsAlpha = false
        colorWell.title = "Color Picker"
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        
        for color in buttonColors {
            buttons.append(createColorButton(color))
            addSubview(buttons.last!)
        }
        
        addSubview(colorWell)
    }
    
    func setColor(color: UIColor) {
        colorWell.selectedColor = color
    }
    
    private func createColorButton(_ color: UIColor) -> UIButton {
        let button = UIButton()
        
        button.backgroundColor = color
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = (bounds.width - ((Constants.padding / 2) * Double(buttons.count - 1) + Constants.padding * 2)) / Double(buttons.count + 1)
        var x = Constants.padding
        for button in buttons {
            button.frame = CGRect(x: x, y: Constants.padding, width: width, height: bounds.height - (Constants.padding * 2))
            x += (Constants.padding / 2) + width
            
            button.layer.cornerRadius = Constants.cornerRadiusInner
        }
        
        colorWell.frame = CGRect(x: x, y: Constants.padding, width: width, height: bounds.height - (Constants.padding * 2))
        x += (Constants.padding / 2) + width
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        if let color = sender.backgroundColor {
            colorWell.selectedColor = color
            delegate?.colorViewDidUpdate(withColor: color)
        }
    }
    
    @objc private func colorChanged() {
        if let color = colorWell.selectedColor {
            delegate?.colorViewDidUpdate(withColor: color)
        }
    }
}
