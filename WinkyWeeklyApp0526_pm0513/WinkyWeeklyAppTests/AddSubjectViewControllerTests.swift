//
//  AddSubjectViewControllerTests.swift
//  WinkyWeeklyAppTests
//
//  Created by 김가은 on 5/22/25.
//
import XCTest
@testable import WinkyWeeklyApp

var validator: AddSubjectValidator!

final class AddSubjectValidationTests: XCTestCase {

    func test_과목이름이비었을때_저장실패한다() {
        // 준비: 빈 이름과 선택된 색상
        let subjectName = ""
        let selectedColors = ["#FF5E5E"]

        // 테스트 대상 로직 (유효성 검사 조건)
        let isValid = !subjectName.isEmpty && !selectedColors.isEmpty

        // 검증: 이름이 비었으면 저장은 실패해야 함
        XCTAssertFalse(isValid, "과목명이 비었는데도 유효하다고 판단되었습니다.")
    }
    func test_색상이선택되지않았을때_저장실패한다() {
        // 준비: 이름만 있고 색상 없음
        let subjectName = "수학"
        let selectedColors: [String] = []

        // 테스트 대상 로직
        let isValid = !subjectName.isEmpty && !selectedColors.isEmpty

        // 검증: 색상이 비었으면 저장은 실패해야 함
        XCTAssertFalse(isValid, "색상이 선택되지 않았는데도 유효하다고 판단되었습니다.")
    }
    func test_이름과색상이입력되었을때_저장성공한다() {
        // 준비
        let subjectName = "과학"
        let selectedColors = ["#FFB72B"]

        // 테스트 대상 로직
        let isValid = !subjectName.isEmpty && !selectedColors.isEmpty

        // 검증: 둘 다 존재하면 저장 가능해야 함
        XCTAssertTrue(isValid, "정상 입력인데도 저장이 안 된다고 판단되었습니다.")
    }
    func test_색상이선택되지않았을때_저장실패() {
        // given
        let name = "영어"
        let colors: [String] = [] // ❌ 선택 안함

        // when
        let isValid = validator.isValid(name: name, colors: colors)

        // then
        XCTAssertFalse(isValid)
    }
    func test_이름과색상이모두유효할때_저장성공() {
        // given
        let name = "수학"
        let colors = ["#FF0000"]

        // when
        let isValid = validator.isValid(name: name, colors: colors)

        // then
        XCTAssertTrue(isValid)
    }
    
    
    
}
