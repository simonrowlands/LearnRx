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

example(of: "Filter") {
    let disposeBag = DisposeBag()
    let numberList = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    
    numberList
        .filter({ $0 % 2 == 0 })
        .subscribe(onNext: { element in
            print(element)
        }).disposed(by: disposeBag)
}
