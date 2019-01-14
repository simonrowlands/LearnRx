//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      CHALLENGE CHEAT SHEET      */

example(of: "Challenge 1: Never") {
    let observable = Observable<Any>.never()
    
    observable
        .do(onSubscribed: {
            print("Subscribed!")
        }, onDispose: {
            print("Disposed!")
        })
        .subscribe(onNext: { element in
            print(element)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: DisposeBag())
}

example(of: "Challenge 2: Never") {
    let observable = Observable<Any>.never()
    
    observable
        .debug("Challenge 2 Debug", trimOutput: true)
        .subscribe(onNext: { element in
            print(element)
        }, onCompleted: {
            print("Completed")
        }).disposed(by: DisposeBag())
}

/*      CHALLENGE 2     */

// Challenge 3a: Single
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

// Challenge 3b: Single
example(of: "Challenge 3b") {
    
    let disposeBag = DisposeBag()
    
    loadText(from: "myTextFile").subscribe { single in
        
        switch single {
        case .success(let string):
            print(string)
            
        case .error(let error):
            print(error)
        }
    }.disposed(by: disposeBag)
}
