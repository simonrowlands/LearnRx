//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      CHALLENGE 1: Never
 
 In this first challenge, you should attempt to subscribe to this Never Observable. In the examples we only used a .subscribe(onNext:) method but for this challenge you should attempt to use the .do(...) method in addition to (and before) the subscription. Try typing it out and use Xcodes autocomplete to see the various handlers it provides.
 
 You should see that it provides side effects not included in the .subscribe method. Try adding the onSubscribed and onDispose handlers, in addition to a subscription to complete the challenge.
 
 Tip:
 Don't forget to dispose of the subscription afterwards! You can achieve this with a DisposeBag or directly with .dispose()
 
 */

example(of: "Challenge 1: Never") {
    let _ = Observable<Any>.never()
    
}





/*      CHALLENGE 2: Debug Operator
 Once you have completed the above challenge, copy and paste the code into the below function.
 
 There is an Rx debug operator .debug(), you can use this operator to view any outputs created from events such as onSubscribe, similar to the above code.
 
 To complete this challenge, replace the .do() operator with the .debug() operator
 
 Tips:
 Remember: You still need to keep the subscription!
 
 */

example(of: "Challenge 2: Never") {
    
}






/*      CHALLENGE 3a: Single

 A good example to use is a function that loads text from a file, this may succeed with a value or fail with an error and so it is well suited to a Single.
 
 Within this function it should return a single(.error) in one or more conditions or return a single(.success) on a successful read.
 
 Note:
 This is the way you read a file from the disk as of Swift 4.2
 
 guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else { return }
 guard let data = FileManager.default.contents(atPath: path) else { return }
 guard let contents = String(data: data, encoding: .utf8) else { return }
 -success
 
 The failure enums have been provided for you
 
 Tips:
 Create a function that returns a Single<String>
 Use Single.create { }
 Return an .error(error) or a .success(value)
 */

enum FileReadError: Error {
    case fileNotFound, unreadable, encodingFailed
}

func loadText(from filename: String) {
    
}






/*      CHALLENGE 3b
 
 Now we have a function that returns a Single, we should create an example() function that handles the response.
 
 You should create a function that subscribes to the returned Single and prints out the contents on success or the error on a failure.
 
 Tips:
 Use .subscribe { response in }
 Create a switch case on the response for the different events i.e. success/error
 */

example(of: "Challenge 3b") {
    
}