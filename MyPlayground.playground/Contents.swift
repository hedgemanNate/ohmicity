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


let calendar = Calendar.current
let today = Date()
