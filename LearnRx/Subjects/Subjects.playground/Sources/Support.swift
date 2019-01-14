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
    public func printMe(tag: String?) {
        self.subscribe(onNext: { element in
            if let tag = tag {
                print("\(tag): \(element)")
            } else {
                print(element)
            }
        }).disposed(by: DisposeBag())
    }
}
