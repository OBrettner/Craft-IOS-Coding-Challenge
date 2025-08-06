import UIKit

class ViewController: UIViewController {
    var thumbnail = Thumbnail(data: .defaultThumbnailData)
    var changeFontContainer = ContainerView()
    var changeColorContainer = ContainerView()
    var changeImageContainer = ContainerView()
    
    private let changeFontChildView = ChangeFontView()
    private let changeColorChildView = ChangeColorView()
    private let changeImageChildView = ChangeThumbnailImageView()
    private let thumbnailActionsView = ThumbnailActionsView()
    
    var thumbnailView = ThumbnailView()
    
    var currentActiveEditView: ActiveView?
    
    var sideLength: CGFloat {
        view.frame.width / 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try thumbnail.load()
        } catch {
            print("Loading was not successfull")
        }
        
        
        setupThumbnailContainerView()
        setupChaneFontView()
        setupChangeColorView()
        setupChangeImageView()
        
        thumbnailView.text = thumbnail.codableData.userName.initials
        thumbnailView.fontFamily = thumbnail.codableData.fontName
        thumbnailView.backgroundColor = thumbnail.codableData.backgroundColor.uiColor
        thumbnailView.thumbnailImage = thumbnail.codableData.imageData?.image
        setImageOnlyMode(on: thumbnail.codableData.hasImage)
    }
    
    private func setupThumbnailContainerView() {
        let thumbnailContainer = UIView()
        let nameLabel = UILabel()
        
        thumbnailContainer.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        thumbnailContainer.isUserInteractionEnabled = true
        
        nameLabel.text = thumbnail.codableData.userName
        nameLabel.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        
        thumbnailActionsView.delegate = self
        
        thumbnailContainer.addSubview(thumbnailActionsView)
        thumbnailContainer.addSubview(thumbnailView)
        thumbnailContainer.addSubview(nameLabel)
        
        view.addSubview(thumbnailContainer)
        
        NSLayoutConstraint.activate([
            thumbnailContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            thumbnailContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            thumbnailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            thumbnailContainer.heightAnchor.constraint(equalToConstant: sideLength),
            
            thumbnailActionsView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 20),
            thumbnailActionsView.trailingAnchor.constraint(equalTo: thumbnailContainer.trailingAnchor, constant: 0),
            thumbnailActionsView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0),
            thumbnailActionsView.bottomAnchor.constraint(equalTo: thumbnailView.bottomAnchor, constant: 0),
            
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: thumbnailContainer.trailingAnchor, constant: 0),
            nameLabel.topAnchor.constraint(equalTo: thumbnailContainer.topAnchor, constant: 20),
            
            thumbnailView.heightAnchor.constraint(equalToConstant: sideLength),
            thumbnailView.widthAnchor.constraint(equalToConstant: sideLength),
            thumbnailView.leadingAnchor.constraint(equalTo: thumbnailContainer.leadingAnchor, constant: 20),
            thumbnailView.topAnchor.constraint(equalTo: thumbnailContainer.topAnchor, constant: 20),
        ])
    }
    
    private func changeVisibleEditView(active: ActiveView?) {
        guard currentActiveEditView != active else {
            return
        }
        
        if currentActiveEditView != nil {
            switch currentActiveEditView {
            case .font:
                Animations.animateOut(view: changeFontContainer)
            case .color:
                Animations.animateOut(view: changeColorContainer)
            case .image:
                Animations.animateOut(view: changeImageContainer)
            case nil:
                print("Unknown Editor is active!")
            }
        }
        
        if let nextActive = active {
            switch nextActive {
            case .font:
                view.bringSubviewToFront(changeFontContainer)
                Animations.animateIn(view: changeFontContainer)
            case .color:
                view.bringSubviewToFront(changeColorContainer)
                Animations.animateIn(view: changeColorContainer)
            case .image:
                view.bringSubviewToFront(changeImageContainer)
                Animations.animateIn(view: changeImageContainer)
            }
        }
        
        currentActiveEditView = active
    }
    
    private func createPopupView(height: CGFloat) -> ContainerView {
        let containerView = ContainerView.createPopupView(height: height, parent: view)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleCloseEditorSwipe))
        swipeDown.direction = .down
        containerView.addGestureRecognizer(swipeDown)
        
        return containerView
    }
    
    @IBAction func handleCloseEditorSwipe(_ gestureRecognizer : UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            changeVisibleEditView(active: nil)
        }
    }
    
    private func setupChaneFontView() {
        changeFontContainer = createPopupView(height: 140)
        
        changeFontChildView.delegate = self
        changeFontChildView.setActiveSelectedButton(active: thumbnail.codableData.fontName)
        changeFontContainer.addSubviewToContainer(changeFontChildView)
        
        NSLayoutConstraint.activate([
            changeFontChildView.leadingAnchor.constraint(equalTo: changeFontContainer.leadingAnchor, constant: 10),
            changeFontChildView.trailingAnchor.constraint(equalTo: changeFontContainer.trailingAnchor, constant: -10),
            changeFontChildView.bottomAnchor.constraint(equalTo: changeFontContainer.bottomAnchor, constant: -10),
            changeFontChildView.topAnchor.constraint(equalTo: changeFontContainer.topAnchor, constant: 26),
        ])
        
        changeFontContainer.isHidden = true
    }
    
    private func setupChangeColorView() {
        changeColorContainer = createPopupView(height: 140)
        
        changeColorChildView.delegate = self
        changeColorContainer.addSubviewToContainer(changeColorChildView)
        
        NSLayoutConstraint.activate([
            changeColorChildView.leadingAnchor.constraint(equalTo: changeColorContainer.leadingAnchor, constant: 10),
            changeColorChildView.trailingAnchor.constraint(equalTo: changeColorContainer.trailingAnchor, constant: -10),
            changeColorChildView.bottomAnchor.constraint(equalTo: changeColorContainer.bottomAnchor, constant: -10),
            changeColorChildView.topAnchor.constraint(equalTo: changeColorContainer.topAnchor, constant: 26),
        ])
        
        changeColorContainer.isHidden = true
    }
    
    private func setupChangeImageView() {
        changeImageContainer = createPopupView(height: 100)
        
        changeImageChildView.delegate = self
        changeImageContainer.addSubviewToContainer(changeImageChildView)
        
        NSLayoutConstraint.activate([
            changeImageChildView.leadingAnchor.constraint(equalTo: changeImageContainer.leadingAnchor, constant: 10),
            changeImageChildView.trailingAnchor.constraint(equalTo: changeImageContainer.trailingAnchor, constant: -10),
            changeImageChildView.bottomAnchor.constraint(equalTo: changeImageContainer.bottomAnchor, constant: -10),
            changeImageChildView.topAnchor.constraint(equalTo: changeImageContainer.topAnchor, constant: 26),
        ])
        
        changeImageContainer.isHidden = true
    }
    
    private func setImageOnlyMode(on: Bool) {
        if on {
            thumbnailActionsView.changeLayoutTo(layoutType: .image)
        } else {
            thumbnailActionsView.changeLayoutTo(layoutType: .noImage)
        }
    }
}

extension ViewController: ChangeFontViewDelegate {
    func fontViewDidUpdate(_ childView: ChangeFontView, withFontName fontName: String) {
        thumbnailView.fontFamily = fontName
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontName: fontName,
                    backgroundColor: thumbnail.codableData.backgroundColor,
                    imageData: thumbnail.codableData.imageData
                )
            )
    }
}

extension ViewController: ChangeColorViewDelegate {
    func colorViewDidUpdate(_ childView: ChangeColorView, withColor color: UIColor) {
        thumbnailView.backgroundColor = color
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontName: thumbnail.codableData.fontName,
                    backgroundColor: CodableColor(uiColor: color),
                    imageData: thumbnail.codableData.imageData
                )
            )
    }
}

extension ViewController: ChangeThumbnailImageViewDelegate {
    func imageViewDidUpdate(_ childView: ChangeThumbnailImageView, with image: UIImage) {
        thumbnailView.thumbnailImage = image
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontName: thumbnail.codableData.fontName,
                    backgroundColor: thumbnail.codableData.backgroundColor,
                    imageData: CodableImage(image: image)
                )
            )
        setImageOnlyMode(on: thumbnail.codableData.hasImage)
    }

    func presentAlert(_ childView: ChangeThumbnailImageView, viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension ViewController: ThumbnailActionsViewDelegate {
    func editButtontapped(_ childView: ThumbnailActionsView, active: ActiveView) {
        changeVisibleEditView(active: active)
    }

    func removeImageButtonTapped(_ childView: ThumbnailActionsView) {
        thumbnail
            .updateData(
                thumbnailData: ThumbnailData(
                    userName: thumbnail.codableData.userName,
                    fontName: thumbnail.codableData.fontName,
                    backgroundColor: thumbnail.codableData.backgroundColor,
                    imageData: nil
                )
            )
        
        thumbnailView.thumbnailImage = nil
        setImageOnlyMode(on: thumbnail.codableData.hasImage)
    }
}
