//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      SUBJECTS
 
 When you use an Observable it only emits an output. You can subscribe to an observables output, but you can’t change it.
 
 A Subject is an observable which can also take inputs; meaning that you can manually emit new elements, rather than just monitoring its outputs.
 
 Similar to Observables, Subjects have several traits available to them. These traits are:
 
 Publish Subject
 Replay Subject
 Behaviour Subject
 
 // Variable - This will be/has been deprecated due to inconsistencies and so will not be covered here
 
 Subject traits differ in the way that they emit next events, they do not differ in the way they emit stop events:
 All subject traits will re-emit stop/completed events to new subscribers meaning that all future subscribers will be notified that the subject has been terminated.
*/




/*      Publish Subject
 
 Publish Subjects only emit new next events to subscribers. It will not replay any previous next events.
 This is useful when you only want to receive live events and do not care about previous ones.
 
 */

example(of: "Publish Subject") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    
    // You can cast the subject as it inherits from Observable
    let observable: Observable<String> = subject
    
    subject.onNext("Number one") // This value is emitted (but unused), despite there being no subscriber
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number two")
}


/*      Behaviour Subject
 
 Behaviour Subjects differ to Publish Subjects in the way that they emit the last onNext event they received
 This means that a new subscriber will receive the last next event when it subscribes, in addition to any future events.
 
 */

example(of: "Behaviour Subject") {
    let disposeBag = DisposeBag()
    
    let subject = BehaviorSubject<String>(value: "Number zero") // Note how it must be initialised with a value
    let observable: Observable<String> = subject
    
    subject.onNext("Number one")
    subject.onNext("Number two")
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number three")
}


/*      Replay Subject
 
 Behaviour Subjects differ to Behaviour Subjects in the way that they emit the all previous onNext events up to their buffer size
 This means that a new subscriber will receive all of the previous events when it subscribes, up to the buffer limit, in addition to any future events.
 
 */

example(of: "Replay Subject") {
    
    let disposeBag = DisposeBag()
    
    let subject = ReplaySubject<String>.create(bufferSize: 3)
    let observable: Observable<String> = subject
    
    subject.onNext("Number one")
    subject.onNext("Number two")
    subject.onNext("Number three")
    subject.onNext("Number four")
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number five")
}

/*
 To complete this chapter, attempt the challenges in the SubjectsChallenges playground located within this folder.
 There are only two challenges!
 */
