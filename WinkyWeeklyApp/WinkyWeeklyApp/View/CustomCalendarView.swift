import UIKit

protocol CustomCalendarViewDelegate: AnyObject {
    func calendarView(_ calendarView: CustomCalendarView, didSelect date: Date)
    func calendarViewDidToggleScope(_ calendarView: CustomCalendarView, isMonthly: Bool) // ✅ 추가
}

final class CustomCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    private let dataManager = MyDateManager()
    private(set) var selectedDate: Date
    private var dates: [Date] = []

    var isMonthly: Bool = true {
        didSet { updateCalendar()
        
        }
    }
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: CustomCalendarViewDelegate?

    private let monthLabel = UILabel()
    private let headerStack = UIStackView()
    private let weekdayStackView = UIStackView()
    private var collectionView: UICollectionView!

    // MARK: - Init
    init(selectedDate: Date, isMonthly: Bool = true) {
        self.selectedDate = selectedDate
        self.isMonthly = isMonthly
        super.init(frame: .zero)
        setupHeader()
        setupWeekdayStack()
        setupCollectionView()
        setupSwipeGestures()
        updateCalendar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Header
    private func setupHeader() {
        let prevButton = UIButton(type: .system)
        prevButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        prevButton.tintColor = .darkGray
        prevButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)

        let nextButton = UIButton(type: .system)
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.tintColor = .darkGray
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        monthLabel.font = .boldSystemFont(ofSize: 18)
        monthLabel.textAlignment = .center
        monthLabel.textColor = .label
        monthLabel.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleScope))
        monthLabel.addGestureRecognizer(tap)

        // ✅ [수정 전] headerStack 정의만 하고 사용하지 않음
        // ✅ [수정 후] 실제 stackView로 구성
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalCentering
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        headerStack.addArrangedSubview(prevButton)
        headerStack.addArrangedSubview(monthLabel)
        headerStack.addArrangedSubview(nextButton)

        addSubview(headerStack) // ✅ 꼭 뷰 계층에 추가해야 함

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            headerStack.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    // MARK: - Weekdays
    private func setupWeekdayStack() {
        weekdayStackView.axis = .horizontal
        weekdayStackView.distribution = .fillEqually
        weekdayStackView.translatesAutoresizingMaskIntoConstraints = false

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        for symbol in formatter.shortWeekdaySymbols {
            let label = UILabel()
            label.text = symbol
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 13)
            label.textColor = .gray
            weekdayStackView.addArrangedSubview(label)
        }

        addSubview(weekdayStackView)

        NSLayoutConstraint.activate([
            weekdayStackView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: isMonthly ? 4 : 0),
            weekdayStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            weekdayStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            weekdayStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Collection View
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        addSubview(collectionView)

        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: isMonthly ? 240 : 40)
        collectionViewHeightConstraint.isActive = true

 
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: weekdayStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

//    // MARK: - Update Calendar
    private func updateCalendar() {
        dates = isMonthly
            ? dataManager.generateMonthDates(for: selectedDate)
            : dataManager.generateWeekDates(for: selectedDate)
        monthLabel.text = formattedMonth(from: selectedDate)
        collectionView.reloadData()
    }
    private func formattedMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }

    // MARK: - Actions
    @objc private func didTapPrev() {
        let offset = isMonthly ? -1 : -7
        selectedDate = Calendar.current.date(byAdding: isMonthly ? .month : .day, value: offset, to: selectedDate) ?? selectedDate
        updateCalendar()
    }

    @objc private func didTapNext() {
        let offset = isMonthly ? 1 : 7
        selectedDate = Calendar.current.date(byAdding: isMonthly ? .month : .day, value: offset, to: selectedDate) ?? selectedDate
        updateCalendar()
    }

    @objc private func toggleScope() {
        isMonthly.toggle()
        updateCalendar()
        delegate?.calendarViewDidToggleScope(self, isMonthly: isMonthly) // ✅ 여기서 알림
    }
    
    private func setupSwipeGestures() {
        let left = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        left.direction = .left
        collectionView.addGestureRecognizer(left)

        let right = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        right.direction = .right
        collectionView.addGestureRecognizer(right)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let offset = (gesture.direction == .left) ? (isMonthly ? 1 : 7) : (isMonthly ? -1 : -7)
        selectedDate = Calendar.current.date(byAdding: isMonthly ? .month : .day, value: offset, to: selectedDate) ?? selectedDate
        updateCalendar()
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = dates[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell

        let isToday = dataManager.isToday(date)
        let isSelected = dataManager.isSameDay(date, selectedDate)
        let isInMonth = dataManager.isSameMonth(date, selectedDate)

        cell.configure(date: date, isToday: isToday, isSelected: isSelected, isInMonth: isInMonth)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates[indexPath.item]
        delegate?.calendarView(self, didSelect: selectedDate)
        updateCalendar()
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 7
        let spacing: CGFloat = 4 * (columns - 1)
        let width = (collectionView.bounds.width - spacing) / columns
        let rows: CGFloat = isMonthly ? 6 : 1
//        let height = (collectionView.bounds.height - (rows - 1) * 4) / rows
        let height: CGFloat = isMonthly ? (collectionView.bounds.height - (rows - 1) * 4) / rows : 48 // ✅ 주간일 땐 고정 높이
        return CGSize(width: width, height: height)
    }
}
