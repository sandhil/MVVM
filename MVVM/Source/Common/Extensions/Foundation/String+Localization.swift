import Foundation

func localizedString(forKey key: String) -> String {
    
    let brandString = NSLocalizedString(key, tableName: "Brand", comment: "")
    let key = brandString.contains("@string/") ? brandString.replacingOccurrences(of: "@string/", with: "") : key
    
    var localizedString =  NSLocalizedString(key, comment: "")
    
    if localizedString.lowercased() == key || localizedString.isEmpty {
        let path = Bundle.main.path(forResource: "en", ofType: "lproj")!
        localizedString = Bundle(path: path)!.localizedString(forKey: key, value: key, table: nil)
    }
    
    return localizedString.replacing("u00AD", with: "\u{00AD}")
}

func localizedString(forKey key: String, arguments: CVarArg...) -> String {
    var localizedStr = localizedString(forKey: key)
    localizedStr = localizedStr.replacingOccurrences(of: "%s", with: "%@")
    return String(format: localizedStr, arguments: arguments)
}
