//
//  CalendarViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/20/25.
//
import UIKit


class CalendarViewController: UIViewController {
    
    // MARK: - UI 요소
    private var resolutionToday = UITextField()
    
    private let timerCard = UIView()
    private let scheduleCard = UIView()
    private let timerLabel = UILabel()
    private let timerTimeLabel = UILabel()
    private var selectedDate: Date = Date()
    
    private var calendarView: CustomCalendarView!
    private var calendarHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupResolutionToday()
        setupCalendarView()
        setupCards()
        
        //subject데이터모델관련 과목관리버튼
        setupFloatingAddButton() // ✅ 플로팅 버튼 추가
    }
    
    // MARK: - 오늘의 다짐 입력창
    private func setupResolutionToday() {
        resolutionToday.placeholder = "오늘의 다짐을 입력하세요"
        resolutionToday.borderStyle = .roundedRect
        resolutionToday.font = .systemFont(ofSize: 16)
        resolutionToday.translatesAutoresizingMaskIntoConstraints = false
        
        // ✏️ 연필 아이콘 추가
        let pencilImage = UIImageView(image: UIImage(systemName: "pencil"))
        pencilImage.tintColor = .gray
        pencilImage.contentMode = .scaleAspectFit
        resolutionToday.rightView = pencilImage
        resolutionToday.rightViewMode = .always
        
        view.addSubview(resolutionToday)
        
        NSLayoutConstraint.activate([
            resolutionToday.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            resolutionToday.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resolutionToday.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resolutionToday.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - 달력 뷰
    private func setupCalendarView() {
        calendarView = CustomCalendarView(selectedDate: selectedDate)
        calendarView.delegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)

        calendarHeightConstraint = calendarView.heightAnchor.constraint(equalToConstant: 300) // 초기값: 월간
        calendarHeightConstraint.isActive = true

    
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: resolutionToday.bottomAnchor, constant: 24),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
 

    
    // MARK: - setupCard 카드뷰 (홈화면의 타이머, 주간계획)
    private func setupCards() {
        let cardStack = UIStackView()
        cardStack.axis = .horizontal
        cardStack.spacing = 12
        cardStack.distribution = .fillEqually
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardStack)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTimerCard))
        timerCard.addGestureRecognizer(tap)
        timerCard.isUserInteractionEnabled = true
        
        
        // 타이머 카드 설정
        timerCard.backgroundColor = UIColor(white: 0.95, alpha: 1)
        timerCard.layer.cornerRadius = 12
        timerCard.translatesAutoresizingMaskIntoConstraints = false
        timerCard.isUserInteractionEnabled = true
        
        timerLabel.text = "타이머"
        timerLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timerLabel.textAlignment = .left
        
        timerTimeLabel.text = "오늘의 누적시간: 00:00:00"
        timerTimeLabel.font = .systemFont(ofSize: 12)
        timerTimeLabel.textAlignment = .center
        timerTimeLabel.textColor = .darkGray
        
        let timerStack = UIStackView(arrangedSubviews: [timerLabel, timerTimeLabel])
        timerStack.axis = .vertical
        timerStack.spacing = 8
        timerStack.translatesAutoresizingMaskIntoConstraints = false
        
        timerCard.addSubview(timerStack)
        
        NSLayoutConstraint.activate([
            timerStack.leadingAnchor.constraint(equalTo: timerCard.leadingAnchor, constant: 12),
            timerStack.centerYAnchor.constraint(equalTo: timerCard.centerYAnchor)
        ])
        
        // 주간 계획 카드 설정
        scheduleCard.backgroundColor = UIColor(white: 0.95, alpha: 1)
        scheduleCard.layer.cornerRadius = 12
        //        scheduleCard.translatesAutoresizingMaskIntoConstraints = false
        
        let scheduleLabel = UILabel()
        scheduleLabel.text = "블록 달력"
        scheduleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        scheduleLabel.textAlignment = .left
        
        let subjectCountLabel = UILabel()
        // ✅ subjectCountLabel.text = "등록된 과목: \(subjects.count)개" 로 변경해야함!!!!
        subjectCountLabel.text = "과목 : 3 개"
        subjectCountLabel.font = .systemFont(ofSize: 12)
        subjectCountLabel.textAlignment = .center
        subjectCountLabel.textColor = .darkGray
        
        let scheduleStack = UIStackView(arrangedSubviews: [scheduleLabel, subjectCountLabel])
        scheduleStack.axis = .vertical
        scheduleStack.spacing = 8
        scheduleStack.translatesAutoresizingMaskIntoConstraints = false
        
        scheduleCard.addSubview(scheduleStack)
        
        NSLayoutConstraint.activate([
            scheduleStack.leadingAnchor.constraint(equalTo: scheduleCard.leadingAnchor, constant: 20),
            scheduleStack.centerYAnchor.constraint(equalTo: scheduleCard.centerYAnchor)
        ])
        
        cardStack.addArrangedSubview(timerCard)
        cardStack.addArrangedSubview(scheduleCard)
        
        

        
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 20),
            cardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardStack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @objc private func didTapTimerCard() {
        let selectedDate = calendarView.selectedDate  // ✅ CustomCalendarView의 현재 선택된 날짜
        print("🟢 타이머 카드가 눌렸습니다")
        let vc = TimerViewController(selectedDate: selectedDate)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 과목 관리 버튼 추가
    private func setupFloatingAddButton() {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .white
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 28
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addSubjectButtonTapped), for: .touchUpInside)
        
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    // MARK: - 버튼 동작
    @objc private func addSubjectButtonTapped() {
        let managerVC = SubjectManagerViewController()
        navigationController?.pushViewController(managerVC, animated: true)
    }
    
}
extension CalendarViewController: CustomCalendarViewDelegate {
    
    func calendarViewDidToggleScope(_ calendarView: CustomCalendarView, isMonthly: Bool) {
        adjustCalendarHeight(isMonthly: isMonthly)
    }

    func calendarView(_ calendarView: CustomCalendarView, didSelect date: Date) {
        selectedDate = date
        adjustCalendarHeight(isMonthly: calendarView.isMonthly)
    }
    
    // ✅ 중복 제거한 공통 메서드
    private func adjustCalendarHeight(isMonthly: Bool) {
        let newHeight: CGFloat = isMonthly ? 300 : 100
        calendarHeightConstraint.constant = newHeight
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
