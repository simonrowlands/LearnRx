//  LearnRx
//
//  Created by Simon Rowlands on 10/01/2019.
//  Copyright © 2019 simonrowlands. All rights reserved.
//

import RxSwift

/*      CHALLENGES      */


example(of: "Challenge 1: Never") {
    
}

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
 
 */

example(of: "Challenge 3b") {
    
}
