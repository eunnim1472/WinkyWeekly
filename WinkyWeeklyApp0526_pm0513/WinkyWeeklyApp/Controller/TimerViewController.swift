//
//  TimerViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/20/25.
//

import UIKit


class TimerViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedDate: Date
    private let totalTimeLabel = UILabel()    // 누적시간을 위한 레이블
    
    private var calendarView: CustomCalendarView!
    private var calendarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Init -> 이부분은 그냥 필수지만 규칙으로 정해져있어서 복붙하는 부분
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "타이머"
        
        setupCalendarView()
        setupTotalTimeLabel()
        setupBottomSections()
    }
    // MARK: - 달력뷰세팅
    private func setupCalendarView() {
        calendarView = CustomCalendarView(selectedDate: selectedDate)
        calendarView.delegate = self
        calendarView.isMonthly = false  // 타이머 화면은 기본 주간 모드
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)

        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 100) // 주간 기준 높이
        calendarHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - 누적 시간
    private func setupTotalTimeLabel() {
        totalTimeLabel.font = .boldSystemFont(ofSize: 40)
        totalTimeLabel.textColor = .black
        totalTimeLabel.textAlignment = .left
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalTimeLabel)

        NSLayoutConstraint.activate([
            totalTimeLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 15),
            totalTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalTimeLabel.heightAnchor.constraint(equalToConstant: 60)
        ])

        updateTotalTimeLabel()
    }

    private func updateTotalTimeLabel() { // 시간 표시용
        let seconds = TimerManager.shared.getTime(for: selectedDate)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds
        totalTimeLabel.text = String(format: "%02d:%02d:%02d", h, m, s)
    }
    
    //두 항목을 같은 라인에 가로로 나열하고, 그 옆에 얇은 회색 선(0.5pt)을 연결합니다.
    private func setupBottomSections() { //
        let subjectsLabel = UILabel()
        subjectsLabel.text = "SUBJECTS"
        subjectsLabel.font = .systemFont(ofSize: 8)
        subjectsLabel.textColor = .lightGray
        subjectsLabel.translatesAutoresizingMaskIntoConstraints = false

        let subjectsLine = UIView()
        subjectsLine.backgroundColor = .lightGray
        subjectsLine.translatesAutoresizingMaskIntoConstraints = false

        let timelineLabel = UILabel()
        timelineLabel.text = "TIMELINE"
        timelineLabel.font = .systemFont(ofSize: 8)
        timelineLabel.textColor = .lightGray
        timelineLabel.translatesAutoresizingMaskIntoConstraints = false

        let timelineLine = UIView()
        timelineLine.backgroundColor = .lightGray
        timelineLine.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(subjectsLabel)
        view.addSubview(subjectsLine)
        view.addSubview(timelineLabel)
        view.addSubview(timelineLine)

        NSLayoutConstraint.activate([
            // 🔹 subjects
            subjectsLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 20),
            subjectsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            subjectsLine.centerYAnchor.constraint(equalTo: subjectsLabel.firstBaselineAnchor), // ✅ baseline 정렬
            subjectsLine.leadingAnchor.constraint(equalTo: subjectsLabel.trailingAnchor, constant: 8),
            subjectsLine.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            subjectsLine.heightAnchor.constraint(equalToConstant: 0.5), // ✅ 얇은 선

            // 🔹 TIMELINE
            timelineLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 20),
            timelineLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            timelineLine.centerYAnchor.constraint(equalTo: timelineLabel.firstBaselineAnchor),
            timelineLine.leadingAnchor.constraint(equalTo: timelineLabel.trailingAnchor, constant: 8),
            timelineLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timelineLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    
}

// 이 싱글톤 클래스는 날짜별 누적 시간을 저장하고 불러오는 기능을 합니다.
//누적 시간은 타이머 화면, 메인 화면, 주간 계획 등 여러 곳에서 참조하거나 저장해야 함.
//UserDefaults와 같은 글로벌 저장소와 맞물
// 메모리 효율성과 구조적 단순함
final class TimerManager {
    static let shared = TimerManager()
    
    private init() {}

    // ✅ 저장 (TimeInterval 사용으로 명확화)
    func saveTime(_ duration: TimeInterval, for date: Date) {
        let key = keyFor(date: date)
        let total = UserDefaults.standard.double(forKey: key)
        UserDefaults.standard.set(total + duration, forKey: key)
    }
    
    // ✅ 불러오기
    func getTime(for date: Date) -> Int {
        let key = keyFor(date: date)
        let total = UserDefaults.standard.double(forKey: key)
        return Int(total)
    }
    
    // ✅ 리셋 (초기화)
    func resetTime(for date: Date) {
        let key = keyFor(date: date)
        UserDefaults.standard.removeObject(forKey: key)
    }

    // ✅ 모든 저장된 날짜 키 확인 (디버깅 또는 전체 시간 관리 용도)
    func allDateKeys() -> [String] {
        return UserDefaults.standard.dictionaryRepresentation().keys
            .filter { $0.starts(with: "time_") }
    }
    
    // ✅ key 생성 방식 분리
    private func keyFor(date: Date) -> String {
        return "time_\(Self.dateFormatter.string(from: date))"
    }

    // ✅ DateFormatter 싱글 인스턴스로 재사용 (성능 개선)
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

extension TimerViewController: CustomCalendarViewDelegate {
    func calendarViewDidToggleScope(_ calendarView: CustomCalendarView, isMonthly: Bool) {
        let newHeight: CGFloat = isMonthly ? 300 : 100
        calendarHeightConstraint.constant = newHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    func calendarView(_ calendarView: CustomCalendarView, didSelect date: Date) {
        selectedDate = date
        updateTotalTimeLabel()
    }
}
