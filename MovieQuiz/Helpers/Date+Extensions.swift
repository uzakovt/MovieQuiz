import Foundation

extension Date {
    var dateTimeString: String {
        DateFormatter.defaultDateTime.string(from: self)
    }
}

private extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        return dateFormatter
    }()
}