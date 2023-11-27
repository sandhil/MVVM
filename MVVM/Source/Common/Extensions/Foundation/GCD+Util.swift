import Foundation

func runOnUIThread(execute block: @escaping () -> Void) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

func runOnUIThread(after: DispatchTime, execute block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: after, execute: block)
}
