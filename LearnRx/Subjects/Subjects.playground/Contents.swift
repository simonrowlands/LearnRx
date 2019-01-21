//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      SUBJECTS
 
 When you create an Observable it only emits an output. You can subscribe to an observables output, but you cannot alter it.
 
 A Subject is an Observable which can also take new inputs; meaning that you can manually emit new elements.
 
 Similar to Observables, Subjects have several traits available to them. These traits are:
 
 Publish Subject
 Replay Subject
 Behaviour Subject
 
 // Variable - This will be/has been deprecated due to inconsistencies and so will not be covered here
 
 The Subject traits all emit stop/completed events in the same way, they differ however in the way that they emit next events
 
 All subject traits will re-emit stop/completed events to new subscribers meaning that all future subscribers will be immediately notified that a subject has been terminated.
*/




/*      Publish Subject
 
 Publish Subjects only emit new values to subscribers. It will not replay any previously emitted values.
 
 We create an Observable cast from the Subject to subscribe to
 We emit new values on the subject itself
 */

example(of: "Publish Subject") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    
    // You can cast the subject as it inherits from Observable
    let observable: Observable<String> = subject
    
    subject.onNext("Number one") // This value is added to the emission stream despite there being no subscriber
    
    observable.subscribe(onNext: { text in
        print(text)
    }).disposed(by: disposeBag)
    
    subject.onNext("Number two")
}


/*      Behaviour Subject
 
 Behaviour Subjects differ to Publish Subjects in the way that they also emit the last value emitted
 This means that a new subscriber will receive the last emission when it subscribes, in addition to any future values.
 
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
 
 Behaviour Subjects differ to Behaviour Subjects in the way that they emit the all previous emitted values up to their buffer size
 This means that a new subscriber will receive all of the previous values when it subscribes, up to the buffer limit, in addition to any future values.
 
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
