//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

enum MyError: Error {
    case anError
}

var one = 1
var two = 2
var three = 3
var numbers = [one, two, three]

example(of: "just, of, from") {
    
    let just = Observable.just(one)
    let of = Observable.of(one, two, three)
    let ofArray = Observable.of(numbers)
    let from = Observable.from(numbers)
    
    // NOTE: printMe is a custom extension on the Observable class. It uses the RxSwift `subscribe` function to print the elements which will be explained below
    
    just.printMe("Just")
    of.printMe("Of")
    ofArray.printMe("Of array")
    from.printMe("From array")
}

example(of: "subscribe") {
    
    let observable = Observable.of(one, two, three)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}

example(of: "never") {
    let observable = Observable<Any>.never()
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}
