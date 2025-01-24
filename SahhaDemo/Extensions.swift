// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI

// MARK: View

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

fileprivate var ymdFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd" // Example: "2021-10-27"
    return dateFormatter
}

fileprivate var dateTimeFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ" // Example: "2021-10-27T16:34:06-06:00"
    return dateFormatter
}

fileprivate var utcOffsetFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "ZZZZZ" // Example: "-06:00"
    return dateFormatter
}

extension Date {
    var toYYYYMMDD: String {
        return ymdFormatter.string(from: self)
    }
    var toDateTime: String {
        return dateTimeFormatter.string(from: self)
    }
    var toUTCOffsetFormat: String {
        return utcOffsetFormatter.string(from: self)
    }
}
