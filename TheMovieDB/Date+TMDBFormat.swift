//
//  Date+TMDBFormat.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation

extension Date {

    /// Converts the given date to the format used by The Movie DB API.
    /// - Returns: The formated date string.
    func toTMDBFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }


    /// Adds months to the given date.
    /// - Parameter months: The number of months to add.
    /// - Returns: The new date.
    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months

        return calendar.date(byAdding: components, to: self)
    }
}
