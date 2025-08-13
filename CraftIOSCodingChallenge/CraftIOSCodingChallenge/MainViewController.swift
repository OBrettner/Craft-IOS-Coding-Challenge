import UIKit

struct Constants {
    static let padding = 15.0
    static let sidePadding = 10.0
    
    static let cornerRadiusOuther = 20.0
    static let cornerRadiusInner = 12.0
}

class MainViewController: UIViewController {
    var thumbnail = Thumbnail(data: .defaultThumbnailData)
    
    var nameInputField = SignalTextView()
    var thumbnailView = ThumbnailView()
    var settingsView = ThumbnailSettingsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try thumbnail.load()
        } catch {
            print("Loading was not successfull")
        }
        
        nameInputField.onEditingFinished = onNameInputUpdated
        nameInputField.text = thumbnail.codableData.userName
        
        thumbnailView.text = thumbnail.codableData.userName.initials
        thumbnailView.fontDesign = thumbnail.codableData.fontDesign
        thumbnailView.backgroundColor = thumbnail.codableData.backgroundColor.uiColor
        thumbnailView.thumbnailImage = thumbnail.codableData.imageData?.image
        let thumbnailTapped = UITapGestureRecognizer(target: self, action: #selector(thumbnailtapped))
        thumbnailView.addGestureRecognizer(thumbnailTapped)
        
        settingsView.setActiveFontDesign(fontDesign: thumbnail.codableData.fontDesign)
        settingsView.setImageStateActive(active: thumbnail.codableData.hasImage)
        settingsView.setActiveColor(color: thumbnail.codableData.backgroundColor.uiColor)
        
        settingsView.view.isHidden = true
        settingsView.delegate = self
        addChild(settingsView)
        
        view.addSubview(thumbnailView)
        view.addSubview(nameInputField)
        view.addSubview(settingsView.view)
        
        settingsView.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        thumbnailView.frame = getThumbnailCGRect()
        nameInputField.frame = getNameInputFieldCGRect()
        settingsView.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }
    
    func getThumbnailCGRect() -> CGRect {
        let sideSize = min(view.bounds.width, view.bounds.height) * 0.3
        let x = (view.bounds.width - sideSize) / 2
        let y = (view.bounds.height - sideSize) / 4
        return CGRect(x: x, y: y, width: sideSize, height: sideSize)
    }
    
    func getNameInputFieldCGRect() -> CGRect {
        let width = min(view.bounds.width, view.bounds.height) - (Constants.sidePadding * 2)
        let height = 40.0
        let x = (view.bounds.width - width) / 2
        let y = thumbnailView.frame.maxY + Constants.padding
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @objc func thumbnailtapped() {
        Animations.fadeIn(view: settingsView.view)
        nameInputField.isEnabled = false
        settingsView.view.setNeedsLayout()
    }
    
    func onNameInputUpdated(name: String?) {
        if let newName = name {
            thumbnailView.text = newName.initials
            thumbnail
                .updateData(
                    thumbnailData: ThumbnailData(
                        userName: newName,
                        fontDesign: thumbnail.codableData.fontDesign,
                        backgroundColor: thumbnail.codableData.backgroundColor,
                        imageData: thumbnail.codableData.imageData
                    )
                )
        }
    }
}

extension MainViewController: SettingsViewDelegate {
    func imageViewDidUpdate(with image: UIImage?) {
        thumbnailView.thumbnailImage = image
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontDesign: thumbnail.codableData.fontDesign,
                    backgroundColor: thumbnail.codableData.backgroundColor,
                    imageData: image == nil ? nil : CodableImage(image: image!)
                )
            )
    }

    func backgroundColorDidUpdate(withColor color: UIColor) {
        thumbnailView.backgroundColor = color
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontDesign: thumbnail.codableData.fontDesign,
                    backgroundColor: CodableColor(uiColor: color),
                    imageData: thumbnail.codableData.imageData
                )
            )
    }

    func fontViewDidUpdate(withDesign fontDesign: UIFontDescriptor.SystemDesign) {
        thumbnailView.fontDesign = fontDesign
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontDesign: fontDesign,
                    backgroundColor: thumbnail.codableData.backgroundColor,
                    imageData: thumbnail.codableData.imageData
                )
            )
    }

    func closeSettingsView() {
        Animations.fadeOut(view: settingsView.view)
        nameInputField.isEnabled = true
    }
}
