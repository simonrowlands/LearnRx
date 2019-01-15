//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/* Challenge 1: Publish Subject */

example(of: "Challenge 1: Publish Subject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    let observable: Observable<String> = subject
    
    subject.onNext("Number one")
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number two")
}

/* Challenge 2: Replay Subject */

let one = 1
let two = 2
let three = 3

example(of: "Challenge 2: Replay Subject") {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<Int>.create(bufferSize: 2)
    let observable: Observable<Int> = subject
    
    subject.onNext(one)
    subject.onNext(two)
    subject.onNext(three)
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
}
