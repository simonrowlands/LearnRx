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
    let _ = Observable.just(one)
    let _ = Observable.of(one, two, three)
    let _ = Observable.of(numbers)
    let _ = Observable.from(numbers)
    
    /*
     Note how there is no output in the console here, this is because there is no subscriber listening for the events!
     We cover subscribers in the function below
     */
}

example(of: "subscribe") {
    let observable = Observable.of(one, two, three)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
    /*
     Now we have subscribed and added a print on receiving each next event, we can see the elements output in the console
     */
}


/*
 An Empty observable is simply an observable with no elements. As a type is required, we use `Void` to declare it.
 An Empty observable will never emit next events but will emit completed/terminated events.
 */

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}


/*
 A Never observable is similar to an Empty observable; it has no values and will not emit next events.
 The difference here though is that it does not emit completed events as it never terminates!
 Try running the playground; you will see that there is no "Completed" log below
 */

example(of: "never") {
    let observable = Observable<Any>.never()
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onCompleted: {
        print("Completed")
    })
}


/*      CHALLENGE

You should now be able to attempt challenge 1 in the `ObservableChallenges` playground located in this group folder.
You can refer back to the above examples if needed, bonus points if you don't have to!
 
        CHALLENGE       */



/*
 There are several initializers for observables as we have seen above, there are some more covered below
 Most of these are self explanatory but are covered for clarity and reference
 */

/*
 You can declare an observable with a range, this will give the observable a sequence using the values of the range i.e. 1 - 10
 This is the same as declaring an Observable using .of(1, 2, 3...)
 */

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable.subscribe(onNext: { i in
        print(fibonacciNumber(from: i))
    })
}

/*
 Subscriptions in Rx are `Disposable` types. When you subscribe to an Observable, the Subscription (or Disposable) keeps a strong reference to the Observable. This means that there is a retain cycle: If the user tries to pop a view using Observables from the navigation stack, the Observables will never be de-allocated.
 
 RxSwift counters this issue with its own deallocation method: dispose() as shown below
 
 This disposes of the Subscription immediately meaning that you could keep this code in the ViewControllers deinit method to dispose the Subscriptions on navigating backwards
 
 */

example(of: "dispose") { // Manually disposing
    let observable = Observable.of("A", "B", "C").subscribe(onNext: { element in
        print(element)
    }, onDisposed: {
        print("Disposed!")
    })
    observable.dispose()
}

/*
 There is a more convenient way of handling the disposal of subscriptions, this is the Rx class `DisposeBag`
 DisposeBags track all of the disposables that are added to them and disposes them all when it is deinitialised
 */

example(of: "DisposeBag") { // Automatically disposing
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C").subscribe {
        print($0)
    }.disposed(by: disposeBag)
    
    Observable.of("D", "E", "F").subscribe {
        print($0)
    }.disposed(by: disposeBag)
}

/*
 This does cause further potential for a retain cycle however; you must be careful not to use disposed(by:) when the subscription has a strong reference to the ViewController
 
 This is because the ViewController has a strong reference to the DisposeBag, the DisposeBag has a strong reference to the Subscription and the Subscription has a strong reference to the ViewController
 
 You can avoid this by using .dispose() or using a weak reference within the Subscription
 
 Below are some examples of these scenarios
 */

example(of: "DisposeBag retain cycle") {
    
    class HomeViewController: UIViewController {
        
        let numberLabel: UILabel? = nil
        
        let disposeBag = DisposeBag() // Strong reference ViewController -> DisposeBag
        
        let one = 1
        let two = 2
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let observable = Observable.of(one, two)
            
            // Bad
            observable.subscribe(onNext: { element in
                self.numberLabel?.text = "\(element)" // Strong reference Subscription -> ViewController
            }).disposed(by: disposeBag) // Strong reference DisposeBag -> Subscription
            
            // Good
            observable.subscribe(onNext: { [weak self] element in
                self?.numberLabel?.text = "\(element)" // WEAK reference Subscription -> ViewController
            }).disposed(by: disposeBag) // Strong reference DisposeBag -> Subscription
        }
    }
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
                maybe(.error(MaybeError.badError))
            }
        } else {
            maybe(.completed)
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
