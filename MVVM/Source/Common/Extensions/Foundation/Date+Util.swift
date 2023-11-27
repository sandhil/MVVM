import Foundation
import SwiftDate

extension Date {
 
    func with(_ component: Calendar.Component, changedWith f: (Int) -> Int) -> Date? {
        let currentValue = dateComponents.value(for: component)!
        return self.with(component, setTo: f(currentValue))
    }
    
    func with(_ component: Calendar.Component, setTo value: Int) -> Date? {
        
        var correctedValue = value
        
        switch component {
        case .nanosecond: correctedValue = value.clamp(to: 0...999_999_999)
        case .second: correctedValue = value.clamp(to: 0...59)
        case .minute: correctedValue = value.clamp(to: 0...59)
        case .hour: correctedValue = value.clamp(to: 0...23)
        default: break
        }
        
        return self.dateTruncated(from: component)?.dateBySet([component : correctedValue])
    }
    
    func with(hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
        return dateBySet(hour: hour?.clamp(to: 0...23), min: minute?.clamp(to: 0...59), secs: second?.clamp(to: 0...59))!
    }
    
    func nameOfWeekday(timeZone: TimeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())!) -> String {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let weekdaySymbols = Calendar.current.weekdaySymbols
        let weekday = weekdaySymbols[calendar.component(.weekday, from: self) - 1]
        return weekday
    }
    
    func toISOString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        return formatter.string(from: self)
    }
    
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.isLenient = true
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
    func age() -> Int? {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year], from: self, to: Date())
        return components.year
    }
}

enum RoundingOptions {
    case toNearest(multipleOf: Int, Calendar.Component)
    case upToNext(multipleOf: Int, Calendar.Component)
    case downToNext(multipleOf: Int, Calendar.Component)
}
