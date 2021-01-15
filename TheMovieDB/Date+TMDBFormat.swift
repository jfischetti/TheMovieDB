//
//  Date+TMDBFormat.swift
//  TheMovieDB
//
//  Created by Joseph Fischetti on 1/14/21.
//

import Foundation

extension Date {
    func toTMDBFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    func adding(months: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.month = months

        return calendar.date(byAdding: components, to: self)
    }
}
