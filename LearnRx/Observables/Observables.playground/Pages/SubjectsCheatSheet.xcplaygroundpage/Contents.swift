//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*:
 ### Page Links

 [Go to the Subjects page](Subjects)
 
 [Go to the Challenges](SubjectsChallenges)
 
 [Go to the next chapter - Operators](Operators)
 */

//: ## CHALLENGE CHEAT SHEET

//: ### Challenge 1: Publish Subject

example(of: "Challenge 1: Publish Subject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    let observable: Observable<String> = subject.asObservable()
    
    subject.onNext("Number one")
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number two")
}

//: ### Challenge 2: Replay Subject

example(of: "Challenge 2: Replay Subject") {
    let disposeBag = DisposeBag()
    let subject = ReplaySubject<Int>.create(bufferSize: 2)
    let observable: Observable<Int> = subject.asObservable()
    
    subject.onNext(1)
    subject.onNext(2)
    subject.onNext(3)
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
}
