import Foundation

public func example(of description: String, action: () -> Void) {
    print("""
    
    >>> Example of: \(description)
    """)
    action()
    print("<<<")
}

public func fibonacciNumber(from n: Int) -> Int {
    return fibonacciNumbers(from: n).last!
}

func fibonacciNumbers(from n: Int) -> [Int] {
    guard n > 1 else { return [1] }
    guard n > 2 else { return [1, 1] }
    var fib: [Int] = []
    fib.append(1)
    fib.append(1)
    for i in 2..<n {
        fib.append(fib[i-1]+fib[i-2])
    }
    return fib
}
