import Foundation

import RxSwift

public func example(of description: String, action: () -> Void) {
    print("""
    
    >>> Example of: \(description)
    """)
    action()
    print("<<<")
}

extension Observable {
    public func printMe(_ id: String? = nil) {
        self.subscribe(onNext: { element in
            if let id = id {
                print("\(id): \(element)")
            } else {
                print(element)
            }
        }).disposed(by: DisposeBag())
    }
}
