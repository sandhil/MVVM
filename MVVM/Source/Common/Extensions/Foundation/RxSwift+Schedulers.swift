import Foundation
import RxSwift

class Schedulers {
    
    static let main = MainScheduler.instance
    static let io = ConcurrentDispatchQueueScheduler(qos: .background)
    static let computation = {
        return OperationQueueScheduler(operationQueue: OperationQueue())
    }()
    
}
