//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

var one = 1
var two = 2
var three = 3
var numbers = [one, two, three]

example(of: "just, of, from") {
    
    let just = Observable.just(one)
    let of = Observable.of(one, two, three)
    let ofArray = Observable.of(numbers)
    let from = Observable.from(numbers)
    
    /* NOTE:
     printMe is a custom extension on the Observable class.
     It uses the RxSwift `subscribe` function to print the elements which will be explained below
     It is used here as the above statements by themselves do not provide an output
    */
    just.printMe(tag: "Just")
    of.printMe(tag: "Of")
    ofArray.printMe(tag: "Of array")
    from.printMe(tag: "From array")
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


/*      CHALLENGE

You should now be able to attempt challenges 1 & 2 in the `ObservableChallenges` playground located in this group folder.
You can refer back to the above examples if needed, bonus points if you don't have to!
 
        CHALLENGE       */

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable.subscribe(onNext: { i in
        let fibonacci = fibonacciNumber(from: i)
        print(fibonacci)
    })
}

example(of: "dispose") { // Manually disposing
    let observable = Observable.of("A", "B", "C").subscribe {
        print($0)
    }
    observable.dispose()
}

example(of: "DisposeBag") { // Automatically disposing
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C").subscribe {
        print($0)
    }.disposed(by: disposeBag)
    
    Observable.of("D", "E", "F").subscribe {
        print($0)
    }.disposed(by: disposeBag)
}

example(of: "create") {
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
        case anError
    }
    
    Observable<String>.create { observer in
        observer.onNext("1")
        observer.onError(MyError.anError)
        observer.onCompleted()
        observer.onNext("?")
        return Disposables.create()
    }.subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed")
    }).disposed(by: disposeBag)
}

example(of: "deferred") {
    let disposeBag = DisposeBag()
    var flip = false
    
    let factory: Observable<Int> = Observable.deferred {
        
        flip = !flip
        
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    func subscribe(to observable: Observable<Int>) {
        for _ in 0...2 {
            observable.subscribe(onNext: {
                print($0, terminator: "")
            }).disposed(by: disposeBag)
            print("")
        }
        print()
    }
    
    subscribe(to: factory)
    subscribe(to: factory)
    subscribe(to: factory)
}

/*
 There are three kinds of traits in RxSwift: Single, Maybe, and Completable.
 
 Singles
 Singles will emit either a .success(value) or an .error event.
 .success(value) is actually a combination of the .next and .completed events.
 This is useful for one-time processes that will either succeed and yield a value or fail, such as downloading data or loading it from disk.
 
 Completables
 A Completable will only emit a .completed or .error event.
 It doesn't emit any value.
 You could use a completable when you only care that an operation completed successfully or failed, such as a file write.
 
 Maybes
 Maybe is a mashup of a Single and Completable.
 It can either emit a .success(value), .completed, or .error.
 If you need to implement an operation that could either succeed or fail, and optionally return a value on success, then Maybe is your ticket.
 */


example(of: "Single") {
    
    let disposeBag = DisposeBag()
    
    enum SingleError: Error {
        case badError
    }
    
    let condition = true
    
    Single<String>.create { single in
        
        if condition {
            single(.success("Mathematics!"))
        } else {
            single(.error(SingleError.badError))
        }
        
        return Disposables.create()
        
    }.subscribe { response in
        
        switch response {
        case .success(let response):
            print(response)
            
        case .error(let error):
            print(error)
        }
    }.disposed(by: disposeBag)
}

example(of: "Completable") {
    
    let disposeBag = DisposeBag()
    
    enum CompletableError: Error {
        case badError
    }
    
    let condition = true
    
    Completable.create { completable in
        
        if condition {
            completable(.completed)
        } else {
            completable(.error(CompletableError.badError))
        }
        
        return Disposables.create()
        
    }.subscribe { response in
        
        switch response {
        case .completed:
            print("Completed!")
            
        case .error(let error):
            print(error)
        }
    }.disposed(by: disposeBag)
}

example(of: "Maybe") {
    
    let disposeBag = DisposeBag()
    
    enum MaybeError: Error {
        case badError
    }
    
    let condition = true
    
    Maybe<Int>.create { maybe in
        
        if condition {
            if let number = Int("1") {
                maybe(.success(number))
            } else {
                maybe(.completed)
            }
        } else {
            maybe(.error(MaybeError.badError))
        }
        
        return Disposables.create()
        
    }.subscribe { response in
        
        switch response {
        case .success(let value):
            print(value)
            
        case .completed:
            print("Completed")
            
        case .error(let error):
            print(error)
        }
    }.disposed(by: disposeBag)
}

/*      CHALLENGE
 
 To finish off the Observables chapter you should now be able to attempt challenges 3a & 3b in the `ObservableChallenges` playground located in this group folder.
 
 You can refer back to the above examples if needed, as always bonus points if you don't have to!
 
 CHALLENGE       */
