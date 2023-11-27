import Foundation
import UIKit

extension UICollectionView {
    public func registerCells(nibName: String) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellWithReuseIdentifier: nibName)
    }
    
}
