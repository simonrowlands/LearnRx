//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*  Challenge 1: Map  */

example(of: "Challenge 1: Map") {
    let observable = Observable.range(start: 1, count: 5)
    let disposeBag = DisposeBag()
    
    observable.map {
        $0 * 10
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}

/*  Challenge 2: FlatMap  */
func square(value: Int) -> Observable<Int> {
    return Observable.of(value * value)
}

example(of: "Challenge 2: FlatMap") {
    let observable = Observable.range(start: 1, count: 5)
    let disposeBag = DisposeBag()
    
    observable.flatMap {
        square(value: $0)
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}


/*  Filter Challenge  */

example(of: "Challenge 3: Filter") {
    let observable = Observable.of("Steve", "Simon", "Dave", "Bob", "sam", "Joe", "James")
    let disposeBag = DisposeBag()
    
    observable.filter {
        $0.lowercased().first == "s"
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
}
