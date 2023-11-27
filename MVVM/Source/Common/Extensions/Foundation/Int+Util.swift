import Foundation
import UIKit

extension Int {
    
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    
    func toTimeInterval() -> TimeInterval {
        return TimeInterval(self)
    }
    
    func nearest(multipleOf n: Int) -> Int {
        return roundToNearest(n)
    }
    
    func next(multipleOf n: Int) -> Int {
        
        if n == 0 {
            return self
        }
        
        return self.truncatedTo(multipleOf: n) + n
    }
    
    func previous(multipleOf n: Int) -> Int {
        
        if n == 0 {
            return self
        }
        
        let isDivisableByN = (self % n == 0)
        return self.truncatedTo(multipleOf: n) - (isDivisableByN ? n : 0)
    }
    
    func truncatedTo(multipleOf n: Int) -> Int {
        return self / n * n
    }
    
    func roundToNearest(_ n: Int) -> Int {
        return n == 0 ? self : Int(round(Double(self) / Double(n))) * n
    }
    
    public static func random(inRange range: ClosedRange<Int>) -> Int {
        return random(in: range)
    }
}
