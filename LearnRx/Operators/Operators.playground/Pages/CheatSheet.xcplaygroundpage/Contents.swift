//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

//: ### Challenge 1: Map

example(of: "Challenge 1: Map") {
    let observable = Observable.range(start: 1, count: 5)
    let disposeBag = DisposeBag()
    
    observable.map {
        $0 * 10
    }.subscribe(onNext: { number in
        print(number)
    }).disposed(by: disposeBag)
}

//: ###  Challenge 2: FlatMap
func square(value: Int) -> Observable<Int> {
    return Observable.of(value * value)
}

example(of: "Challenge 2: FlatMap") {
    let observable = Observable.range(start: 1, count: 5)
    let disposeBag = DisposeBag()
    
    observable.flatMap { number in
        square(value: number)
    }.subscribe(onNext: { number in
        print(number)
    }).disposed(by: disposeBag)
}


//: ###  Challenge 3: Filter

example(of: "Challenge 3: Filter") {
    let observable = Observable.of("Steve", "Simon", "Dave", "Bob", "sam", "Joe", "James")
    let disposeBag = DisposeBag()
    
    observable.filter { name in
        name.lowercased().first == "s"
    }.subscribe(onNext: { name in
        print(name)
    }).disposed(by: disposeBag)
}
