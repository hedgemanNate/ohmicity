import Foundation
// The user's calendar incorporates the user's locale and
// time zone settings, which means it's the one you'll use
// most often.
//let calendar = Calendar.current
//let today = calendar.startOfDay(for: Date())
//let dayOfWeek = calendar.component(.weekday, from: today)
//let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
//let days = (weekdays.lowerBound ..< weekdays.upperBound)
//    .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }  // use `flatMap` in Xcode versions before 9.3
//    .filter { !calendar.isDateInWeekend($0) }

var num1: Int?
var num2: Int?
var num3: Int?

num3 = 3
num2 = 2

func foo() {
    let opQueue = OperationQueue()
    opQueue.maxConcurrentOperationCount = 1
    
    let op1 = BlockOperation {
        if num1 != nil {
            print(num1)
        } else {return}
    }
    
    let op2 = BlockOperation {
        if num2 != nil {
            print(num2)
        } else {return}
    }
    
    let op3 = BlockOperation {
        if num3 != nil {
            print(num3!)
        } else {return}
    }
    
    op3.addDependency(op2)
    op2.addDependency(op1)
    opQueue.addOperations([op1, op2, op3], waitUntilFinished: true)
}

foo()
