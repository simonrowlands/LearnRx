//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*
 For all these challenges, when using an Observable/Subscription you should always do the following:
 - Subscribe to the Observable
 - Add the Subscription to a DisposeBag
 */


/* Challenge 1: Publish Subject
 
 Create a Publish Subject
 Create an Observable cast from the subject, this Observable should have some values to emit
 Subscribe to the Observable
 Call onNext(value) on the subject to emit a new value
 
 To complete this challenge - Print an output in the onNext call
 */

example(of: "Challenge 1: Publish Subject") {
    
}

/* Challenge 2: Replay Subject
 
 For this challenge you should create a ReplaySubject<Int> using .create with a bufferSize of 2
 Create an observable cast from the subject
 Call onNext(value) on the subject with value one, two and three (Before you subscribe)
 Subscribe to the Observable
 
 To complete this challenge - Upon subscribing to the observable, have 2, 3 printed in console
 */

let one = 1
let two = 2
let three = 3

example(of: "Challenge 2: Replay Subject") {
    
}
