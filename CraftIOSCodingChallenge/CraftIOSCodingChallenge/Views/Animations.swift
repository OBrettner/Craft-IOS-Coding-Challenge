import UIKit

class Animations {
    public static func animateIn(view: UIView) {
        view.isHidden = false
        view.alpha = 0.0
        view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            view.alpha = 1.0
            view.transform = .identity
        }, completion: nil)
    }

    public static func animateOut(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0.0
            view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { finished in
            if finished {
                view.isHidden = true
            }
        })
    }
}
