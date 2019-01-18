//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*
 Now we have learnt about Observables and Subjects, the final section to look at is Operators!
 
 Rx has many Operators available for use, they can be split into several categories:
 Transforming Operators
 Filtering Operators
 Combining Operators
 Error Handling Operators
 Time Based Operators
 
 Operators are fundamental to Rx, they enable you to react to events emitted by Observables. They can be even be chained together to form more complex processes.
 
 We will look at examples of most of the Operators, you do not have to know all of these Operators of the top of your head, however, this playground has been created as a point of reference in the event that you need to lookup a specific one with an example.
 
 If you would like to see these Operators in diagram form, here is a great site for visualisation: http://rxmarbles.com
 If you would like the full list of Operators, here they are directly from the Rx documentation http://reactivex.io/documentation/operators.html
 */




/*      TRANSFORMING OPERATORS      */



/*
 The Map Operator enumerates over each element in the observable list, performs a transformation and returns a new value.
 
 In the below example, the .map operator checks if the number is even, if it is, it multiplies it by -1.
 
 Note:
 There must always be a return value for each element that is iterated upon
 */

example(of: "Map") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 5)
    
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
    let numberList = Observable.range(start: 1, count: 5)

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
 The "FlatMap" example has been duplicated and combined with a .map operation
 
 Note:
 The map operation is applied to each element emitted from the final Observable
 */

example(of: "FlatMap + Map") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 5)

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

/*
 The Buffer Operator groups emissions together.
 You can group emissions by time i.e. group emissions every 5 seconds
 You can group emissions by count i.e. group every 3 emissions
 You can group using a combination of the above
 */

example(of: "Buffer") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 5)

    numberList
        .buffer(timeSpan: 5, count: 3, scheduler: MainScheduler.instance)
        .subscribe(onNext: {
            print("Line length: \($0)")
        }).disposed(by: disposeBag)
}

/*
 The Scan Operator applies a transformation the initial emission value and emits the new value. It then uses this new value in the next emission transformation
 
 Note:
 It requires a base value to use for the initial transformation
 */

example(of: "Scan") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 0, count: 10)
    
    numberList
        .scan(1, accumulator: { (lastResult, number) -> Int in
            return lastResult + number
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    print("\nFibonacci fun")
    
    /*
     You can reasonably easily make a Fibonacci-esque scan by doing the following (It is missing the first two values, but you get the point)
     */
    
    var lastNumber = 0
    
    numberList
        .scan(1, accumulator: { (lastResult, number) -> Int in
            let returnNumber = lastResult + lastNumber
            lastNumber = lastResult
            return returnNumber
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}




/*      FILTERING OPERATORS     */



/*
 If you are familiar with Swifts filter operator, you should be able to understand how the Rx filter operator works.
 
 For the uninitiated: Filter ignores any values from a sequence that do not match a given predicate.
 In Rx's case it works the same way; next events are only emitted on the remaining values.
 */

example(of: "Filter") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 10)

    numberList
        .filter({ $0 % 2 == 0 })
        .subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
}


/*
 In some cases an Observable may emit a value that is identical to the last value.
 In the event that you only require unique emission values you can use the Distinct Operator.
 
 An example of this would be monitoring Bool emissions and you only want to know when it flips its state.
 */

example(of: "Distinct Until Changed") {
    let disposeBag = DisposeBag()
    let condition = Observable.of(true, true, false, true, true, true, false)
    
    condition
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}


/*
 Below are a few examples of some of the self-explanatory simpler Operators
 Namely: Skip, Take, ElementAt
 */

/*
 Skip skips the first (n) number of emissions
 */

example(of: "Skip") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 10)

    numberList
        .skip(5)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

/*
 SkipWhile skips every element until the condition predicate fails. Once this occurs, every future element is emitted regardless of whether it passes the predicate.
 */

example(of: "SkipWhile") {
    let disposeBag = DisposeBag()
    let numberList = Observable.of(5, 6, 7, 8, 9, 1, 2)
    
    numberList
        .skipWhile { number in
            number < 8
        }
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

/*
 Take takes the first (n) number of elements
 TakeLast takes the last (n) number of elements
 */

example(of: "Take") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 5)

    numberList
        .take(2)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    print("\n->TakeLast")
    
    numberList
        .takeLast(3)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

/*
 ElementAt take the element at the specified index in the stream
 */

example(of: "ElementAt") {
    let disposeBag = DisposeBag()
    let numberList = Observable.range(start: 1, count: 5)

    numberList
        .elementAt(0)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}




/*      COMBINING OPERATORS      */



/*
 Sometimes you may want to combine multiple Observables into a single Observable.
 There are several Operators that handle these situations, some merging the emissions together and some merging the emission streams.
 
 Combine Latest combines the latest emissions from two or more emission streams (AKA Observable Outputs) into a single emission, resulting in what normally may be emitted as "A" and "1, 2" into "A1, A2"
 */

example(of: "CombineLatest") { // Note how the number 1 is emitted twice here, this is because each emission causes a merge from the latest emission from each stream.
    let disposeBag = DisposeBag()
    let stringList = Observable.of("A", "B")
    let numberList = Observable.range(start: 1, count: 3)

    Observable.combineLatest(stringList, numberList)
        .subscribe(onNext: { string, number in
            print("\(string)\(number)")
        }).disposed(by: disposeBag)
}


/*
 The Zip Operator merges the emissions from multiple streams together for each corresponding index.
 In the below example, you can see that there are only two emissions despite there being 5 items in the numberList emission stream.
 */

example(of: "Zip") {
    let disposeBag = DisposeBag()
    let stringList = Observable.of("A", "B")
    let numberList = Observable.range(start: 1, count: 5)

    Observable.zip(stringList, numberList)
        .subscribe(onNext: { string, number in
            print("\(string)\(number)")
        }).disposed(by: disposeBag)
}


/*
 The Merge Operator merges multiple emission streams together.The emissions stay seperate from each other, unlike the above examples.
 
 Note:
 The emissions must be of the same value type, you cannot merge an <Int> and a <String> stream.
 */

example(of: "Merge") {
    let disposeBag = DisposeBag()
    let stringList = Observable.of("A", "B")
    let numberList = Observable.of("C", "D")
    
    Observable.merge(stringList, numberList)
        .subscribe(onNext: { string in
            print("\(string)")
        }).disposed(by: disposeBag)
}




/*      ERROR HANDLING OPERATORS        */



/*
 There are two error handling Operators; Catch and Retry.
 They are both designed to recover from a thrown error from within an emission stream and attempt to continue observing the emissions, or return a default value.
 
 Firstly we have an example of catchError that recreates the Observable and re-subscribes to the emission stream
 Secondly we have an example of catchErrorJustReturn that emits a default value if an error occurs
 */

example(of: "CatchError") {
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
        case error
    }
    
    var flip = true
    
    let numberObservable = Observable<Int>.create { stream in
        stream.onNext(1)
        stream.onNext(2)
        stream.onNext(3)
        
        if flip {
            flip = !flip
            stream.onError(MyError.error)
        }
        stream.onNext(4)
        stream.onNext(5)
        return Disposables.create()
    }
    
    numberObservable
        .catchError({ error -> Observable<Int> in
            print(error)
            return numberObservable
        }).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    print("\n->Catch Error Just Return")
    
    flip = true
    
    numberObservable
        .catchErrorJustReturn(10)
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}

/*
 Here we have an Observable that always fails on the first emission stream and then flips the condition to succeed.
 In the first example we can see that the retry() Operator repeatedly re-attempts the emission stream until it succeeds
 This could cause an infinite loop which is resolved by using the next examples; retry(maxAttempts) and/or using catchErrorJustReturn()
 */

example(of: "Retry") {
    let disposeBag = DisposeBag()

    enum MyError: Error {
        case error
    }
    
    var flip = true
    
    let numberObservable = Observable<Int>.create { stream in
        stream.onNext(1)
        stream.onNext(2)
        stream.onNext(3)
        
        if flip {
            flip = !flip
            stream.onError(MyError.error)
        }
        
        stream.onNext(4)
        stream.onNext(5)
        return Disposables.create()
    }
    
    numberObservable
        .retry() // Be very careful here; if this never succesfully retries it will loop infinitely.
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    
    
    print("\n->Retry with MaxAttempts")
    
    let alwaysErrorObservable = Observable<Int>.create { stream in
        stream.onNext(1)
        stream.onNext(2)
        stream.onNext(3)
        stream.onError(MyError.error)
        stream.onNext(4)
        stream.onNext(5)
        return Disposables.create()
    }
    
    alwaysErrorObservable
        .retry(2) // Note that as it doesn't succeed after the max attempts, it throws an unhandled error
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    
    
    print("\n->Retry with MaxAttempts and Catch")
    
    alwaysErrorObservable
        .retry(2)
        .catchErrorJustReturn(10) // After the max attempts are reached, the default value is returned
        .subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
}




/*      TIME-BASED OPERATORS        */



/*
 There are several time based operators/subscriptions in Rx
 It is difficult to create examples of async operators in playground, therefore there is only one example here.
 
 DelaySubscription needs a 'hot' Observable (one that emits values regardless of having a subscriber or not) to fully display its usage.
 
 Delay delays the emissions of an Observable, meaning that the initial value will not be fired until after the specified amount of time
 
 DelaySubscription delays the point that the subcription starts receiving values.
 
 In theory this would mean that Delay would receive all values i.e. 1, 2, 3, 4 but delayed by (x) amount of time
 DelaySubscription may not receieve all values i.e. 3, 4 depending on the delay
 */

example(of: "Delay") {
    let intervalObservable = Observable<Int>.interval(1 / 3, scheduler: MainScheduler.instance) // This creates an incrementing output until disposed
    
    print("delaySubscriptionSubscribed")
    
    let delaySubscription = intervalObservable
        .delay(2, scheduler: MainScheduler.instance)
        .subscribe(onNext: {
            print($0)
        }, onDisposed: {
            print("<")
        })
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
        delaySubscription.dispose()
    })
}
