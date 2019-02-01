//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*:
 * [Back to the Observables page](@previous)
 * [Go to the Cheat Sheet](@next)
 */

/*:
 ## Challenges
 For all these challenges, when using an Observable/Subscription you should always do the following:
 - Subscribe to the Observable
 - Add the Subscription to a DisposeBag
 */

/*:
 ### Challenge 1: Map
 
 Using map, transform the values of the Observable in any way
 
 To complete this challenge
 - Print the new values from within the subscription
 */

example(of: "Challenge 1: Map") {
    let _ = Observable.range(start: 1, count: 5)
    
}

/*:
 ### Challenge 2: FlatMap
 
 Using flatMap, transform the values of the Observable using the `square(value:)` function
 
 To complete this challenge
 - Print the new values from within the subscription
 */

func square(value: Int) -> Observable<Int> {
    return Observable.of(value * value)
}

example(of: "Challenge 2: FlatMap") {
    let _ = Observable.range(start: 1, count: 5)
    
}

/*:
 ### Challenge 3: Filter
 
 Using filter, remove all values that do not begin with the letter 'S'
 
 To complete this challenge
 - Print the new values from within the subscription
 - Values must only contain Steve, Simon, sam
 */

example(of: "Challenge 3: Filter") {
    let _ = Observable.of("Steve", "Simon", "Dave", "Bob", "Sam", "Joe", "James")
    
}

/*:
 [The answers are available here](@next)
 
 You have now completed all of the chapters, congratulations!
 */
