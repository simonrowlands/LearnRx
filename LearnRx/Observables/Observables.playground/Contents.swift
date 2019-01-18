//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/* RxSwift: What is it?
 
 In the words of Wikipedia, Reactive Programming is:
 Reactive programming is a programming paradigm oriented around data flows and the propagation of change. This means that it should be possible to express static or dynamic data flows with ease in the programming languages used, and that the underlying execution model will automatically propagate changes through the data flow
 
 Or in short; Reactive programming is the idea that we can easily create data flows and automatically react to their changes
 
 RxSwift enables such behaviour using Observables, Subscriptions and Operators, all of which are covered in this project.
 
 `Observable Sequences` or `Observables`, are the data flows we use to emit data events. Everything else in Rx is based on or operates on these Observables. We use Subscriptions to receive and react to these data events and use Operators to perform logic on the data itself.
 
 For now though, lets have a look at Observables and Subscriptions.
 
 Run the playground up to each example to see what it is doing.
 */



/*      Observables     */

/*
 Here are some examples of how we can initialise an Observable.
 Note that once an Observable is initialised with a value, we cannot add new values into its stream, that is covered in the next chapter `Subjects`.
 */

example(of: "just, of, from") {
    let _ = Observable.just(1)
    let _ = Observable.of(1, 2, 3)
    let _ = Observable.of([1, 2, 3])
    let _ = Observable.from([1, 2, 3])
    
    /*
     Note how there is no output in the console here, this is because there is no subscriber listening for the events!
     We cover subscribers in the function below
     */
}

/*
 As mentioned before, we use Subscribers to receive/react to events emitted by Observables.
 Below is a simple example of reacting to an emission via a print
 */

example(of: "subscribe") {
    let observable = Observable.of(1, 2, 3)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
    
    /*
     Now we have subscribed and added a print on receiving each next event, we can see the elements output in the console
     */
}


/*
 An Empty observable is simply an observable with no elements to emit. As a type is required, we use `Void` to declare it.
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
 Try running the playground; you will see that there is no "Completed" event log
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
 There are several initializers for Observables as we have seen above, there are some more covered below
 Most of these are self explanatory but are covered for clarity and reference
 */

/*
 You can declare an observable with a range, this will give the observable a sequence using the values of the range i.e. 1 - 10
 This is the same as declaring an Observable using .of(1, 2, 3...)
 */

example(of: "range") {
    let observable = Observable.range(start: 1, count: 10)
    
    observable.subscribe(onNext: { i in
        print(fibonacciNumber(from: i))
    })
}

/*
 Subscriptions in Rx are `Disposable` types. When you subscribe to an Observable, the Subscription keeps a strong reference to the Observable.
 
 We need to dispose of these Subscriptions and Observables somehow
 
 RxSwift has its own deallocation method: dispose() as shown below
 
 This disposes of the Subscription immediately. If you were using a ViewController, you could keep this code in the ViewControllers deinit method to dispose the Subscriptions on navigating backwards
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
 DisposeBags track all of the Disposables that are added to them and disposes them when the DisposeBag is deinitialised
 */

example(of: "DisposeBag") { // Automatically disposing
    let disposeBag = DisposeBag()
    
    Observable.of("A", "B", "C").subscribe(onNext: { letter in
        print(letter)
    }).disposed(by: disposeBag)
    
    Observable.of("D", "E", "F").subscribe(onNext: { letter in
        print(letter)
    }).disposed(by: disposeBag)
}

/*
 This does cause further potential for a retain cycle however; you must be careful not to use disposed(by:) when the Subscription has a strong reference to the Observables owner
 
 In the ViewController scenario; the ViewController has a strong reference to the DisposeBag, the DisposeBag has a strong reference to the Subscription and the Subscription has a strong reference to the ViewController
 
 You can avoid this by using .dispose() or more simply using a weak reference within the Subscription
 
 Below are some examples of these scenarios
 */

example(of: "DisposeBag retain cycle") {
    
    class HomeViewController: UIViewController {
        
        let numberLabel: UILabel? = nil
        
        let disposeBag = DisposeBag() // Strong reference, ViewController -> DisposeBag
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let observable = Observable.of(1, 2)
            
            // Bad
            observable.subscribe(onNext: { element in
                self.numberLabel?.text = "\(element)" // Strong reference, Subscription -> ViewController
            }).disposed(by: disposeBag) // Strong reference, DisposeBag -> Subscription
            
            // Good
            observable.subscribe(onNext: { [weak self] element in
                self?.numberLabel?.text = "\(element)" // WEAK reference, Subscription -> ViewController
            }).disposed(by: disposeBag) // Strong reference, DisposeBag -> Subscription
        }
    }
}

/*
 Using the .deferred method, you can create a factory that returns an Observable within its closure.
 
 This allows us to use a different Observable depending on a condition or a state, in the below example we are returning a different Observable depending on the state of the `flip` bool.
 
 This is useful in the scenario when you need to retrieve the Observable at a future point in time and at that point return a different Observable depending on a condition
 */

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
        observable.subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
        print()
    }
    
    subscribe(to: factory) // Flips the bool, prints 1 2 3
    subscribe(to: factory) // Flips the bool, prints 4 5 6
    subscribe(to: factory) // Flips the bool, prints 1 2 3
}

/*
 Now we have looked at some of the available initializers for Observables, it is time to create our own!
 
 The .create() method allows us to implement the result of calling .subscribe on the Observable.
 
 As mentioned earlier, Subscriptions are actually of Disposable type and .create() requires a Disposable to be returned. We can use the convenience Disposable initializer: Disposables.create()
 */

example(of: "create") {
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
        case anError
    }
    
    Observable<String>.create { observer in
        observer.onNext("1")
        observer.onError(MyError.anError)
        observer.onCompleted()  // Note how this and the line below is not printed as the error has already terminated the Subscription
        observer.onNext("?")
        return Disposables.create()
    }.subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed")
    }).disposed(by: disposeBag)
}

/* There are three kinds of traits in RxSwift: Single, Maybe, and Completable.
 
 Singles
 Singles will emit either a .success(value) or an .error event.
 The .success(value) is actually a combination of the .next and .completed events.
 This is useful for one-time processes that will either succeed and yield a value or fail, such as downloading data or loading it from disk.
 */

example(of: "Single") {
    
    let disposeBag = DisposeBag()
    
    enum SingleError: Error {
        case anError
    }
    
    let condition = true
    
    Single<String>.create { single in
        
        if condition {
            single(.success("Success!"))
        } else {
            single(.error(SingleError.anError))
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

/* Completables
 A Completable will only emit a .completed or .error event.
 It doesn't emit any value.
 You could use a completable when you only care that an operation completed successfully or failed, such as a file write.
*/

example(of: "Completable") {
    
    let disposeBag = DisposeBag()
    
    enum CompletableError: Error {
        case anError
    }
    
    let condition = true
    
    Completable.create { completable in
        
        if condition {
            completable(.completed)
        } else {
            completable(.error(CompletableError.anError))
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

/*
 Maybes
 Maybe is a combination of a Single and Completable, it can either emit a .success(value), .completed, or an .error.
 If you need to implement an operation that could either succeed or fail, and optionally return a value on success, then you should use Maybe.
 */

example(of: "Maybe") {
    
    let disposeBag = DisposeBag()
    
    enum MaybeError: Error {
        case cannotCast
    }
    
    let someCondition = true
    
    Maybe<Int>.create { maybe in
        
        if someCondition {
            if let number = Int("1") {
                maybe(.success(number))
            } else {
                maybe(.error(MaybeError.cannotCast))
            }
        }
        
        maybe(.completed) // Note how this is only called when neither of the above lines are called
        
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
 
 To finish off the Observables chapter you should now be able to attempt challenges 2a & 2b in the `ObservableChallenges` playground located in this group folder.
 
 You can refer back to the above examples if needed, as always bonus points if you don't have to!
 
 CHALLENGE       */
