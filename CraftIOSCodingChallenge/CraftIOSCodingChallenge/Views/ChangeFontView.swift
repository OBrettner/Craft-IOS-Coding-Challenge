import UIKit

protocol ChangeFontViewDelegate: AnyObject {
    func fontViewDidUpdate(withDesign fontDesign: UIFontDescriptor.SystemDesign)
}

class ChangeFontView: SlidingContainer {
    
    weak var delegate: ChangeFontViewDelegate?
    
    var currentActiveFontButton: UIButton?
    
    var systemFontButton = UIButton.createStyledTextButton(label: "System", design: .default)
    var serifFontButton = UIButton.createStyledTextButton(label: "Serif", design: .serif)
    var monoFontButton = UIButton.createStyledTextButton(label: "Mono", design: .monospaced)
    var roundedFontButton = UIButton.createStyledTextButton(label: "Rounded", design: .rounded)
    
    @objc func changeFontToSystem(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(withDesign: .default)
        setActiveFontDesign(active: .default)
    }
    
    @objc func changeFontToSerif(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(withDesign: .serif)
        setActiveFontDesign(active: .serif)
    }
    
    @objc func changeFontToMono(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(withDesign: .monospaced)
        setActiveFontDesign(active: .monospaced)
    }
    
    @objc func changeFontToRounded(_ sender: UIButton) {
        delegate?.fontViewDidUpdate(withDesign: .rounded)
        setActiveFontDesign(active: .rounded)
    }
    
    override func setup() {
        super.setup()
        
        systemFontButton.addTarget(self, action: #selector(changeFontToSystem), for: .touchUpInside)
        serifFontButton.addTarget(self, action: #selector(changeFontToSerif), for: .touchUpInside)
        monoFontButton.addTarget(self, action: #selector(changeFontToMono), for: .touchUpInside)
        roundedFontButton.addTarget(self, action: #selector(changeFontToRounded), for: .touchUpInside)
        
        addSubview(systemFontButton)
        addSubview(serifFontButton)
        addSubview(monoFontButton)
        addSubview(roundedFontButton)
    }
    
    public func setActiveFontDesign(active fontType: UIFontDescriptor.SystemDesign) {
        switch fontType {
        case .default: setActiveSelectedFontButton(systemFontButton)
        case .monospaced: setActiveSelectedFontButton(monoFontButton)
        case .rounded: setActiveSelectedFontButton(roundedFontButton)
        case .serif: setActiveSelectedFontButton(serifFontButton)
        default:
            print("Unrecognized Font Style")
        }
    }
    
    private func setActiveSelectedFontButton(_ sender: UIButton) {
        if currentActiveFontButton != sender {
            sender.setSelected()
            
            UIView.animate(withDuration: 0.1, animations: {
                self.currentActiveFontButton?.setNotSelected()
            })
            
            currentActiveFontButton = sender
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = (bounds.width - 36) / 2
        let height = (bounds.height - 43) / 2
        
        systemFontButton.frame = CGRect(x: 12, y: 19, width: width, height: height)
        serifFontButton.frame = CGRect(x: width + 24, y: 19, width: width, height: height)
        monoFontButton.frame = CGRect(x: width + 24, y: height + 31, width: width, height: height)
        roundedFontButton.frame = CGRect(x: 12, y: height + 31, width: width, height: height)
        
        systemFontButton.layer.cornerRadius = Constants.cornerRadiusInner
        serifFontButton.layer.cornerRadius = Constants.cornerRadiusInner
        monoFontButton.layer.cornerRadius = Constants.cornerRadiusInner
        roundedFontButton.layer.cornerRadius = Constants.cornerRadiusInner
    }

}
