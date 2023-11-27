import Foundation
import UIKit

extension UITableView {
    
    public func registerCells(nibName: String) {
        let cellNib = UINib(nibName: nibName, bundle: nil)
        self.register(cellNib, forCellReuseIdentifier: nibName)
    }
}
