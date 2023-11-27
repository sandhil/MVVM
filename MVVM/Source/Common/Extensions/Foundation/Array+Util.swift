import Foundation

extension Array {
    
    func all(predicate: (Element) -> Bool) -> Bool {
        return self.map(predicate).reduce(true) { $0 && $1 }
    }
    
    func any(predicate: (Element) -> Bool) -> Bool {
        return self.map(predicate).reduce(false) { $0 || $1 }
    }
    
    func mapNotNil<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        return compactMap(transform)
    }
    
    public func reduce(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element {
        return try reduce(first!, nextPartialResult)
    }
    
    func sortedBy<T: Comparable>(_ propertySelector: (Element) -> T) -> [Element] {
        return self.sorted { propertySelector($0) < propertySelector($1) }
    }
    
    func min<T: Comparable>(by propertySelector: (Element) -> T) -> Element? {
        return self.min { propertySelector($0) < propertySelector($1) }
    }
    
    func max<T: Comparable>(by propertySelector: (Element) -> T) -> Element? {
        return self.max { propertySelector($0) < propertySelector($1) }
    }
    
    func take(_ n: Int) -> Array {
        return Array(self[0..<n])
    }
    
    func distinct<T: Equatable>(by propertySelector: (Element) -> T) -> Array {
        var distinctPropertyValues: [T] = []
        var result: [Element] = []
        for element in self {
            let propertyValue = propertySelector(element)
            if propertyValue ∉ distinctPropertyValues {
                distinctPropertyValues += propertyValue
                result += element
            }
        }
        return result
    }
    
    mutating func removeFirst(where predicate: (Element) -> Bool) {
        
        guard let i = firstIndex(where: predicate) else {
            return
        }
        
        remove(at: i)
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
        
    static func +(array: Array, element: Element) -> Array {
        return array + [element]
    }
    
    static func +=(array: inout Array, element: Element) {
        array = array + element
    }
    
}

extension Array where Element: AnyObject {
    
    static func -(array: Array, element: Element) -> Array {
        return array.filter { $0 !== element }
    }
    
    static func -=(array: inout Array, element: Element) {
        array = array - element
    }
    
}

extension Array where Element: Equatable {
        
    func containsAny(of other: [Element]) -> Bool {
        return self.contains { other.contains($0) }
    }
    
    func containsNone(of other: [Element]) -> Bool {
        return !containsAny(of: other)
    }
    
    func toggled(_ element: Element) -> Array {
        var result = self
        result.toggle(element)
        return result
    }
    
    mutating func toggle(_ element: Element) {
        if element ∈ self {
            removeFirst(element)
        } else {
            append(element)
        }
    }
    
    mutating func replace(_ oldElement: Element, with newElement: Element) {
        let replacementIndex = firstIndex(of: oldElement)!
        remove(at: replacementIndex)
        insert(newElement, at: replacementIndex)
    }
    
    mutating func replaceFirst(where predicate: (Element) -> Bool, with newElement: Element) {
        if let replacementIndex = firstIndex(where: predicate) {
            remove(at: replacementIndex)
            insert(newElement, at: replacementIndex)
        } else {
            append(newElement)
        }
    }
    
    mutating func removeFirst(_ element: Element) {
        removeFirst { $0 == element }
    }
    
    func `where`(_ oldElement: Element, isReplacedWith newElement: Element) -> Array {
        var result = self
        result.replace(oldElement, with: newElement)
        return result
    }
    
    func element(after: Element, wrap: Bool = false) -> Element? {
        guard var index = firstIndex(of: after) else {
            return nil
        }
        index += 1
        return index ∈ indices ? self[index] : wrap ? self[0] : nil
    }
    
    func element(before: Element, wrap: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: before) {
                let firstItem: Bool = (itemIndex == startIndex)
                if wrap && firstItem {
                    return self.last
                } else if firstItem {
                    return nil
                } else {
                    return self[index(before:itemIndex)]
                }
            }
            return nil
        }

    
    
    func intersection(_ other: Array) -> Array {
        return self.filter { $0 ∈ other }
    }
    
    func union(_ other: Array) -> Array {
        return (self + other).distinct()
    }
    
    func distinct() -> Array {
        return self.reduce([]) { result, element in
            element ∈ result ? result : result + element
        }
    }
    
    static func -(lhs: Array, rhs: Array) -> Array {
        return lhs.filter { $0 ∉ rhs }
    }
    
    static func -(array: Array, element: Element) -> Array {
        return array.filter { $0 != element }
    }
    
    static func -=(array: inout Array, element: Element) {
        array = array - element
    }
    
    static func -=(lhs: inout Array, rhs: Array) {
        lhs = lhs - rhs
    }
    
}

extension Array where Element: Hashable {
    
    func toSet() -> Set<Element> {
        return Set(self)
    }
    
    public func associate<Key, Value>(transform: (Element) -> (Key, Value)) -> [Key : Value] {
        var dict: [Key : Value] = [:]
        for element in self {
            let (key, value) = transform(element)
            dict[key] = value
        }
        return dict
    }
    
    public func associate<Key>(by keySelector: (Element) -> Key) -> [Key : Element] {
        return associate { (keySelector($0), $0) }
    }
}

extension Collection {
    
    func getOrElse(at index: Index, defaultValue: Element) -> Element {
        return getOrNil(at: index) ?? defaultValue
    }
    
    func getOrNil(at index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
