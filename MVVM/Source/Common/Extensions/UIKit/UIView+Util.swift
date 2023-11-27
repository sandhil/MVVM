import UIKit

extension UIView {
    func addShadow(cornerRadius: CGFloat? = 10) {
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
    }
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
