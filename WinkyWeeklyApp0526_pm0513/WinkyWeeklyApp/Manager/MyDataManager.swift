//
//  MyDataManager.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/20/25.
//

import Foundation

struct MyDateManager { //달력의 틀을 만드는 데이터매니저
    private let calendar = Calendar.current
    
    
    /// 월간 날짜 배열 생성 (42일: 앞뒤 공백 포함)
    func generateMonthDates(for baseDate: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: baseDate),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }

        var dates: [Date] = []
        var current = firstWeek.start

        while current < lastWeek.end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }
    
    /// 주간 날짜 배열 생성 (7일)
    func generateWeekDates(for date: Date) -> [Date] {
        var week: [Date] = []
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else { return [] }

        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                week.append(day)
            }
        }

        return week
    }
    func isSameMonth(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, equalTo: d2, toGranularity: .month)
    }

    func isSameDay(_ d1: Date, _ d2: Date) -> Bool {
        calendar.isDate(d1, inSameDayAs: d2)
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    func dayComponent(from date: Date) -> Int {
        calendar.component(.day, from: date)
    }
}
