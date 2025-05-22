//
//  AddSubjectValidator.swift
//  WinkyWeeklyAppTests
//
//  Created by 김가은 on 5/22/25.
//

import Foundation

struct AddSubjectValidator {
    func isValid(name: String, colors: [String]) -> Bool {
        return !name.isEmpty && !colors.isEmpty
    }
}
