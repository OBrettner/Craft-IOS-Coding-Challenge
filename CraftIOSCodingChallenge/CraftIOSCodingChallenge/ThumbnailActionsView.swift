import UIKit

enum LayoutType {
    case image, noImage
}

enum ActiveView {
    case font, color, image
}

protocol ThumbnailActionsViewDelegate: AnyObject {
    func editButtontapped(_ childView: ThumbnailActionsView, active: ActiveView)
    func removeImageButtonTapped(_ childView: ThumbnailActionsView)
}

class ThumbnailActionsView: UIView {
    var delegate: ThumbnailActionsViewDelegate?
    
    let editFontButton = UIButton.createImageButton(image: "textformat", label: "Font", color: .purple)
    let editBackgroundButton = UIButton.createImageButton(image: "paintbrush", label: "Color", color: .blue)
    let editImageButton = UIButton.createImageButton(image: "photo", label: "Image", color: .orange)
    let removeImageButton = UIButton.createImageButton(image: "trash", label: "Remove", color: .red)
    
    var currentLayoutType = LayoutType.noImage

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let editButtonsStack = UIStackView.createStack(.horizontal)
        
        editButtonsStack.addArrangedSubview(editFontButton)
        editButtonsStack.addArrangedSubview(editBackgroundButton)
        editButtonsStack.addArrangedSubview(editImageButton)
        editButtonsStack.addArrangedSubview(removeImageButton)
        
        self.addSubview(editButtonsStack)
        
        NSLayoutConstraint.activate([
            editButtonsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            editButtonsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            editButtonsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            editButtonsStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
        
        changeLayoutTo(layoutType: currentLayoutType)
    }
    
    private func setupActions() {
        editFontButton.addTarget(self, action: #selector(editFontTapped), for: .touchUpInside)
        editBackgroundButton.addTarget(self, action: #selector(editBackgroundTapped), for: .touchUpInside)
        editImageButton.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
        removeImageButton.addTarget(self, action: #selector(removeImageTapped), for: .touchUpInside)
    }
    
    public func changeLayoutTo(layoutType: LayoutType) {
        switch layoutType {
        case .image:
            editFontButton.isHidden = true
            editBackgroundButton.isHidden = true
            removeImageButton.isHidden = false
        case .noImage:
            editFontButton.isHidden = false
            editBackgroundButton.isHidden = false
            removeImageButton.isHidden = true
        }
        
        currentLayoutType = layoutType
    }
    
    @objc func editFontTapped() {
        delegate?.editButtontapped(self, active: .font)
    }
    
    @objc func editBackgroundTapped() {
        delegate?.editButtontapped(self, active: .color)
    }
    
    @objc func editImageTapped() {
        delegate?.editButtontapped(self, active: .image)
    }
    
    @objc func removeImageTapped() {
        delegate?.removeImageButtonTapped(self)
    }
}
