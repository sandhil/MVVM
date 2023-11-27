import Foundation
import RxSwift

extension Observable {
    
    func debounce(_ dueTime: RxTimeInterval) -> Observable<Element> {
        return debounce(dueTime, scheduler: Schedulers.main)
    }
    
    func throttle(_ dueTime: RxTimeInterval) -> Observable<Element> {
        return throttle(dueTime, scheduler: Schedulers.main)
    }
    
    func mapThrowOnNil<R>(_ transform: @escaping (Element) throws -> R?) -> Observable<R> {
        return self.map {
            guard let transformed = try transform($0) else {
                throw RuntimeError.nilPointer
            }
            return transformed
        }
    }
}

extension Single {
    
    func mapThrowOnNil<R>(_ transform: @escaping (Element) throws -> R?) -> Single<R> {
        return self.asObservable().mapThrowOnNil(transform).asSingle()
    }
    
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    
    func doOnSuccess(_ onSuccess: @escaping (Element) -> Void) -> PrimitiveSequence<SingleTrait, Self.Element> {
        return self.do(onSuccess: onSuccess, onError: nil, onSubscribe: nil, onSubscribed: nil, onDispose: nil)
    }
    
}
