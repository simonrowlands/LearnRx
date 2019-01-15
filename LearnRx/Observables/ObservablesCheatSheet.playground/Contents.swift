//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      CHALLENGE CHEAT SHEET      */

let one = 1
let two = 2
let three = 3

example(of: "Challenge 1a: Subscribe") {
    let observable = Observable<Int>.of(one, two, three)

    observable
        .subscribe { element in
            print(element)
        }.dispose()
}

example(of: "Challenge 1b: Do") {
    let observable = Observable<Int>.of(one, two, three)

    observable
        .do(onSubscribed: {
            print("Subscribed!")
        }, onDispose: {
            print("Disposed!")
        })
        .subscribe { element in
            print(element)
        }.dispose()
}

example(of: "Challenge 1c: Debug") {
    let observable = Observable<Any>.never()
    
    observable
        .debug("Challenge 1c Debug", trimOutput: true)
        .subscribe { element in
            print(element)
        }.dispose()
}

/*      CHALLENGE 2     */

// Challenge 2a: Single
func loadText(from filename: String) -> Single<String> {
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    return Single.create { single in
        
        let disposable = Disposables.create()
        
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
            single(.error(FileReadError.fileNotFound))
            return disposable
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            single(.error(FileReadError.unreadable))
            return disposable
        }
        
        guard let contents = String(data: data, encoding: .utf8) else {
            single(.error(FileReadError.encodingFailed))
            return disposable
        }
        
        single(.success(contents))
        return disposable
    }
}

// Challenge 2b: Single
example(of: "Challenge 2b") {
    
    let disposeBag = DisposeBag()
    
    loadText(from: "myTextFile").subscribe { response in
        
        switch response {
        case .success(let string):
            print(string)
            
        case .error(let error):
            print(error)
        }
    }.disposed(by: disposeBag)
}
