//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*
 Now we have learnt about Observables and Subjects, the final section to look at is Operators!
 
 Rx has many Operators available for use, they can be split into four categories:
 Filtering Operators
 Transforming Operators
 Combining Operators
 Time Based Operators
 
 Operators are fundamental to Rx, they enable you to react to events emitted by Observables. They can be even be chained together to form more complex processes.
 
 We will look at some common examples of each of these and as always provide a challenge for you to complete.
 
 If you would like to see these Operators in diagram form, here is a great site for visualisation: http://rxmarbles.com
 */



/*
 If you are familiar with Swifts filter operator, you should be able to understand how the Rx filter operator works.
 
 For the uninitiated: Filter ignores any values from a sequence that do not match a given predicate.
 In Rx's case it works the same way; next events are only emitted on the remaining values.
 */

example(of: "Filter") {
    let disposeBag = DisposeBag()
    let numberList = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    
    numberList
        .filter({ $0 % 2 == 0 })
        .subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
}

/*
 The Map Operator enumerates over each element in the observable list, performs a transformation and returns a new value.
 
 In the below example, the .map operator checks if the number is even, if it is it multiplies it by -1.
 
 Note:
 There must always be a return value for each element that is iterated upon
 */

example(of: "Map") {
    let disposeBag = DisposeBag()
    let numberList = Observable.of(1, 2, 3, 4, 5)
    
    numberList
        .map { number in
            if number % 2 == 0 {
                return number * -1
            }
            return number
        }.subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
}

/*
 The FlatMap Operator explanation from the Rx documentation (http://reactivex.io/documentation/operators/flatmap.html) is as follows:
 
 The FlatMap operator transforms an Observable by applying a function that you specify to each item emitted by the source Observable, where that function returns an Observable that itself emits items. FlatMap then merges the emissions of these resulting Observables, emitting these merged results as its own sequence.
 
 At a simpler level; the .flatMap Operator creates a single Observable that emits all of the events from several other Observables.
 
 To explain the comparison between map and flatMap:
 Map uses the values from a stream and returns a new value of any type.
 FlatMap uses the values from a stream and returns an Observable of any type.. which we can then subscribe to.
 */



/*
 In this example, we have a function `doSomeRxLogic` that takes a number and returns an Observable with values created from that number.
 We want to apply `doSomeRxLogic` to each number within the numberList and subscribe to each event emitted.
 
 To achieve this, we are using .flatMap to create an Observable that merges the emission events for each Observable returned from `doSomeRxLogic`.
 
 Note:
 As the returned Observable is a merge of the other Observables, their emissions may interlap.
 
 Meaning that if you merge an Observable with events `A` and an Observable with events `B`, you may not receive a merged emission of:
 AAABBB
 but more likely something like:
 AABABB
 */

example(of: "FlatMap") {
    let disposeBag = DisposeBag()
    
    let numberList = Observable.of(1, 2, 3, 4, 5)
    
    func doSomeRxLogic(on number: Int) -> Observable<Int> { // Emits two events
        return Observable.of(number * 10, number * 100)
    }
    
    numberList
        .flatMap {
            doSomeRxLogic(on: $0)
        }
        /*
         We have now created an Observable that has merged all the Observables created within the flatMap closure
         */
        .subscribe(onNext: { // We are subscribing to receive each event that the new merged Observable emits
            print("Line length: \($0)")
        }).disposed(by: disposeBag)
}

/*
 As mentioned earlier, you can combine different operators together
 In this example, the "FlatMap" example has been duplicated with a .map operation added to it
 The map operation is applied to each element emitted from the Observer
 */
example(of: "FlatMap + Map") {
    let disposeBag = DisposeBag()
    
    let numberList = Observable.of(1, 2, 3, 4, 5)
    
    func doSomeRxLogic(on number: Int) -> Observable<Int> { // Emits two events
        return Observable.of(number * 10, number * 100)
    }
    
    numberList
        .flatMap {
            doSomeRxLogic(on: $0)
        }.map { number in
            number / 10
        }.subscribe(onNext: {
            print("Line length: \($0)")
        }).disposed(by: disposeBag)
}
