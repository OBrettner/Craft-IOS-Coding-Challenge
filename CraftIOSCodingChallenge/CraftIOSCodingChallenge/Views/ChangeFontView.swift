import UIKit

protocol ChangeFontViewDelegate: AnyObject {
    func fontViewDidUpdate(_ childView: ChangeFontView, withFontName fontName: String)
}

class ChangeFontView: UIView {
    
    weak var delegate: ChangeFontViewDelegate?
    
    var currentActiveFontButton: UIButton?
    
    var systemFontButton = FontButton("System", font: nil)
    var serifFontButton = FontButton("Serif", font: UIFont(name: FontTypes.Serif, size: 16))
    var monoFontButton = FontButton("Mono", font: UIFont(name: FontTypes.Mono, size: 16))
    var roundedFontButton = FontButton("Rounded", font: UIFont(name: FontTypes.Rounded, size: 16))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @objc func systemFontTapped(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(self, withFontName: FontTypes.System)
        setActiveSelectedFontButton(sender)
    }
    
    @objc func monoFontTapped(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(self, withFontName: FontTypes.Mono)
        setActiveSelectedFontButton(sender)
    }
    
    @objc func serifFontTapped(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(self, withFontName: FontTypes.Serif)
        setActiveSelectedFontButton(sender)
    }
    
    @objc func roundedFontTapped(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(self, withFontName: FontTypes.Rounded)
        setActiveSelectedFontButton(sender)
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalStack = UIStackView.createStack(.horizontal)
        let leftButtonStack = UIStackView.createStack(.vertical)
        let rightButtonStack = UIStackView.createStack(.vertical)
        
        systemFontButton.addTarget(self, action: #selector(systemFontTapped), for: .touchUpInside)
        serifFontButton.addTarget(self, action: #selector(serifFontTapped), for: .touchUpInside)
        monoFontButton.addTarget(self, action: #selector(monoFontTapped), for: .touchUpInside)
        roundedFontButton.addTarget(self, action: #selector(roundedFontTapped), for: .touchUpInside)
        
        leftButtonStack.addArrangedSubview(systemFontButton)
        leftButtonStack.addArrangedSubview(serifFontButton)
        
        rightButtonStack.addArrangedSubview(monoFontButton)
        rightButtonStack.addArrangedSubview(roundedFontButton)
        
        horizontalStack.addArrangedSubview(leftButtonStack)
        horizontalStack.addArrangedSubview(rightButtonStack)
        
        self.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            horizontalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
        ])
    }
    
    public func setActiveSelectedButton(active fontType: String) {
        switch fontType {
        case FontTypes.System: setActiveSelectedFontButton(systemFontButton)
        case FontTypes.Serif: setActiveSelectedFontButton(serifFontButton)
        case FontTypes.Mono: setActiveSelectedFontButton(monoFontButton)
        case FontTypes.Rounded: setActiveSelectedFontButton(roundedFontButton)
        default: print("Unknown Font Type")
        }
    }
    
    private func setActiveSelectedFontButton(_ sender: UIButton) {
        currentActiveFontButton?.backgroundColor = .gray.withAlphaComponent(0.1)
            
        if currentActiveFontButton == sender {
            currentActiveFontButton = nil
        } else {
            sender.backgroundColor = .purple.withAlphaComponent(0.1)
            
            currentActiveFontButton = sender
        }
    }

}
