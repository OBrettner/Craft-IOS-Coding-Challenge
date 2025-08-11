import UIKit

class SignalTextView: UITextField, UITextFieldDelegate {
    var onEditingFinished: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        self.delegate = self
        borderStyle = .roundedRect
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEditingFinished?(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
