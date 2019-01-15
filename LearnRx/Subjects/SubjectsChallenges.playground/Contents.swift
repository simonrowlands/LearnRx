//  LearnRx
//
//  Created by Simon Rowlands on 14/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/* Challenge 1: Publish Subject
 
 You should create a Publish Subject
 Create an Observable cast from the subject
 Subscribe to the Observable
 Dispose the Subscription using a DisposeBag
 Call onNext(value) on the subject
 
 To complete this challenge - Receive an output upon calling onNext
 */

example(of: "Challenge 1: Publish Subject") {
    
}

/* Challenge 2: Replay Subject
 
 For this challenge you should create a ReplaySubject<Int>, using .create(bufferSize: 2)
 Create an observable cast from the subject
 Call onNext: on the subject
 Subscribe to the Observable
 Dispose of the observable in a way of your choosing
 
 To complete this challenge - Upon subscribing to the observable achieve the output of:
 2
 3
 */

let one = 1
let two = 2
let three = 3

example(of: "Challenge 2: Replay Subject") {
    
}
