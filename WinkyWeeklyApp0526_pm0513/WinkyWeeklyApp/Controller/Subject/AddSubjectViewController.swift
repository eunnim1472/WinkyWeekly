//
//  AddSubjectViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//

import UIKit
import CoreData

// MARK: - 과목 추가 완료 델리게이트 프로토콜 (과목 추가/저장 후 외부에 알림)
protocol AddSubjectViewControllerDelegate: AnyObject {
    func didAddSubject()
}

// MARK: - 과목 추가 뷰컨트롤러
final class AddSubjectViewController: UIViewController {
    
    // MARK: - 델리게이트 선언 (외부로 과목 추가 이벤트 알림)
    weak var delegate: AddSubjectViewControllerDelegate?
    
    // MARK: - UI 요소 선언
    private let nameTextField = UITextField()      // 과목명 입력 필드
    private let defaultColorScrollView = UIScrollView() // 기본 색상용 스크롤뷰
    private let defaultColorStackView = UIStackView()   // 기본 색상 버튼 스택뷰
    private let customColorScrollView = UIScrollView()  // 커스텀 색상용 스크롤뷰
    private let customColorStackView = UIStackView()    // 커스텀 색상 버튼 스택뷰
    private let saveButton = UIButton(type: .system)    // 저장 버튼
    
    // MARK: - 색상 관리 상태 변수
    private let defaultColors: [String] = [
        "#FF5E5E", "#FFB72B", "#4DD091", "#59AFFF", "#AA8DFF",
        "#FF87E2", "#7C7C7C", "#FFE066", "#FFAEBC", "#B5FFD9"
    ] // 기본 제공 색상 HEX 값 배열
    
    private let maxCustomPaletteCount = 10                // 커스텀 색상 팔레트 최대 개수(10)
    private var colorButtons: [UIButton] = []             // 모든 팔레트 버튼 모음 배열
    private var selectedColor: String?                    // 현재 선택된 색상 HEX
    private var selectedButton: UIButton?                 // 현재 선택된 버튼
    
    // 최근 커스텀 색상 HEX 배열(UserDefaults로 영구 저장)
    private var customColorHexArray: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: "RecentCustomColors") ?? Array(repeating: "", count: maxCustomPaletteCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "RecentCustomColors")
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "과목 추가" // 네비게이션 바 제목
        setupUI()          // UI 전체 구성 함수 호출
    }
    
    // MARK: - UI 초기화 전체 호출 함수
    private func setupUI() {
        setupNameTextField()     // 과목명 입력창
        setupColorPaletteArea()  // 색상 팔레트 UI (기본, 커스텀)
        setupSaveButton()        // 저장 버튼
    }
    
    // MARK: - 이름 입력 필드 UI 설정
    private func setupNameTextField() {
        nameTextField.placeholder = "과목 이름 입력"
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - 색상 팔레트 전체 UI 설정
    private func setupColorPaletteArea() {
        // 기본 색상 스크롤뷰 및 스택뷰 설정
        defaultColorScrollView.showsHorizontalScrollIndicator = false
        defaultColorScrollView.translatesAutoresizingMaskIntoConstraints = false
        defaultColorStackView.axis = .horizontal
        defaultColorStackView.alignment = .center
        defaultColorStackView.spacing = 10
        defaultColorStackView.translatesAutoresizingMaskIntoConstraints = false
        defaultColorScrollView.addSubview(defaultColorStackView)
        view.addSubview(defaultColorScrollView)
        
        // 커스텀 색상 스크롤뷰 및 스택뷰 설정
        customColorScrollView.showsHorizontalScrollIndicator = false
        customColorScrollView.translatesAutoresizingMaskIntoConstraints = false
        customColorStackView.axis = .horizontal
        customColorStackView.alignment = .center
        customColorStackView.spacing = 10
        customColorStackView.translatesAutoresizingMaskIntoConstraints = false
        customColorScrollView.addSubview(customColorStackView)
        view.addSubview(customColorScrollView)
        
        // 팔레트 두 줄 오토레이아웃 지정
        NSLayoutConstraint.activate([
            defaultColorScrollView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            defaultColorScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            defaultColorScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            defaultColorScrollView.heightAnchor.constraint(equalToConstant: 36),
            defaultColorStackView.leadingAnchor.constraint(equalTo: defaultColorScrollView.leadingAnchor),
            defaultColorStackView.trailingAnchor.constraint(equalTo: defaultColorScrollView.trailingAnchor),
            defaultColorStackView.topAnchor.constraint(equalTo: defaultColorScrollView.topAnchor),
            defaultColorStackView.bottomAnchor.constraint(equalTo: defaultColorScrollView.bottomAnchor),
            defaultColorStackView.heightAnchor.constraint(equalToConstant: 36),
            
            customColorScrollView.topAnchor.constraint(equalTo: defaultColorScrollView.bottomAnchor, constant: 14),
            customColorScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customColorScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customColorScrollView.heightAnchor.constraint(equalToConstant: 36),
            customColorStackView.leadingAnchor.constraint(equalTo: customColorScrollView.leadingAnchor),
            customColorStackView.trailingAnchor.constraint(equalTo: customColorScrollView.trailingAnchor),
            customColorStackView.topAnchor.constraint(equalTo: customColorScrollView.topAnchor),
            customColorStackView.bottomAnchor.constraint(equalTo: customColorScrollView.bottomAnchor),
            customColorStackView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        reloadColorPalettes() // 팔레트 전체 버튼 및 상태 리로드
    }
    
    // MARK: - 팔레트 버튼 전체 생성/갱신 함수
    private func reloadColorPalettes() {
        // 모든 버튼, 스택뷰 초기화 (클린업)
        colorButtons.removeAll()
        defaultColorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        customColorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 1. 기본 팔레트 버튼(색상 10개) 생성
        for hex in defaultColors {
            let button = makeCircleButton(color: UIColor(hex: hex), size: 28)
            button.accessibilityIdentifier = hex // 선택 시 식별용
            button.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)
            defaultColorStackView.addArrangedSubview(button)
            colorButtons.append(button)
        }
        
        // 2. 커스텀 팔레트 버튼(빈 원 or 색상, 총 10개) 생성
        for i in 0..<maxCustomPaletteCount {
            let hex = customColorHexArray[i]
            let buttonColor: UIColor = (hex.isEmpty ? .clear : UIColor(hex: hex))
            let button = makeCircleButton(color: buttonColor, size: 28, border: true)
            button.accessibilityIdentifier = (hex.isEmpty ? nil : hex)
            button.tag = i + defaultColors.count // 인덱스 부여(커스텀 버튼 구분)
            
            // 탭: 빈 원이면 컬러피커, 색상 있으면 선택
            button.addTarget(self, action: #selector(customPaletteTapped(_:)), for: .touchUpInside)
            // 롱프레스: 색상 있으면 삭제
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(customPaletteLongPressed(_:)))
            button.addGestureRecognizer(longPress)
            
            customColorStackView.addArrangedSubview(button)
            colorButtons.append(button)
        }
        // 버튼 테두리/상태 일괄 반영 (선택 유지)
        updateAllPaletteBorders(selected: selectedButton)
    }
    
    // MARK: - 팔레트 버튼 테두리 전체 스타일 일괄 적용
    private func updateAllPaletteBorders(selected: UIButton? = nil) {
        for button in colorButtons {
            if button == selected {
                // 선택된 버튼은 파란 테두리
                button.layer.borderWidth = 2.4
                button.layer.borderColor = UIColor.systemBlue.cgColor
            } else if let hex = button.accessibilityIdentifier, !hex.isEmpty {
                // 색상있는 버튼은 해당 색상 테두리
                button.layer.borderWidth = 1.5
                button.layer.borderColor = UIColor(hex: hex).cgColor
            } else {
                // 빈 원은 회색 테두리
                button.layer.borderWidth = 1.5
                button.layer.borderColor = UIColor.systemGray3.cgColor
            }
        }
    }
    
    // MARK: - 원형 색상버튼 생성 함수
    private func makeCircleButton(color: UIColor, size: CGFloat = 28, border: Bool = false) -> UIButton {
        let size: CGFloat = 32 // 버튼 크기(고정)
        let button = UIButton(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = size / 2
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        if border {
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.systemGray3.cgColor
        }
        return button
    }
    
    // MARK: - 팔레트 이벤트(기본색상)
    @objc private func colorTapped(_ sender: UIButton) {
        // 기본색상 클릭 시 해당 색상 선택, 나머지 테두리 리셋
        guard let hex = sender.accessibilityIdentifier else { return }
        updateAllPaletteBorders(selected: sender)
        selectedColor = hex
        selectedButton = sender
    }
    
    // MARK: - 팔레트 이벤트(커스텀)
    @objc private func customPaletteTapped(_ sender: UIButton) {
        // 커스텀 팔레트 클릭 시
        let idx = sender.tag - defaultColors.count
        guard idx >= 0 && idx < maxCustomPaletteCount else { return }
        let hex = customColorHexArray[idx]
        if hex.isEmpty {
            // 빈 원이면 컬러피커 표시
            presentColorPicker(for: sender)
        } else {
            // 색상 있으면 해당 색상 선택
            updateAllPaletteBorders(selected: sender)
            selectedColor = hex
            selectedButton = sender
        }
    }
    @objc private func customPaletteLongPressed(_ gesture: UILongPressGestureRecognizer) {
        // 커스텀 팔레트 롱프레스 시 (색상 있을 때만 삭제)
        guard gesture.state == .began else { return }
        guard let button = gesture.view as? UIButton else { return }
        let idx = button.tag - defaultColors.count
        guard idx >= 0 && idx < maxCustomPaletteCount else { return }
        let hex = customColorHexArray[idx]
        if hex.isEmpty { return }
        presentDeleteCustomColorAlert(for: idx, button: button)
    }
    
    // MARK: - ColorPicker/Alert UI 함수 분리
    private func presentColorPicker(for button: UIButton) {
        // 컬러피커 표시 (해당 버튼 인덱스 전달)
        let picker = UIColorPickerViewController()
        picker.selectedColor = .white
        picker.delegate = self
        picker.view.tag = colorButtons.firstIndex(of: button) ?? -1
        present(picker, animated: true)
    }
    private func presentDeleteCustomColorAlert(for idx: Int, button: UIButton) {
        // 커스텀 색상 삭제 액션시트 표시
        let alert = UIAlertController(title: "색상 삭제", message: "이 커스텀 색상을 삭제하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.deleteCustomColor(at: idx, button: button)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
    private func deleteCustomColor(at idx: Int, button: UIButton) {
        // 해당 커스텀 색상 HEX를 빈 값으로 만들고, 팔레트 갱신
        var hexes = customColorHexArray
        hexes[idx] = ""
        customColorHexArray = hexes
        reloadColorPalettes()
        // 삭제한 버튼이 선택되어 있었으면 선택도 해제
        if selectedButton == button {
            selectedButton = nil
            selectedColor = nil
        }
    }
}

// MARK: - ColorPicker Delegate: 색상 선택 완료 시 처리
extension AddSubjectViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        // 컬러피커에서 색상 선택 완료 시
        let selectedColor = viewController.selectedColor
        let idx = viewController.view.tag
        guard idx >= 0, idx < colorButtons.count else { return }
        let button = colorButtons[idx]
        let hexString = selectedColor.toHexString()
        button.backgroundColor = selectedColor
        button.accessibilityIdentifier = hexString
        
        // 선택된 색상 HEX를 커스텀 팔레트에 저장
        if idx - defaultColors.count >= 0 && idx - defaultColors.count < maxCustomPaletteCount {
            var hexes = customColorHexArray
            hexes[idx - defaultColors.count] = hexString
            customColorHexArray = hexes
        }
        // 팔레트 테두리/상태 갱신 (선택 표시)
        updateAllPaletteBorders(selected: button)
        self.selectedColor = hexString
        self.selectedButton = button
    }
}

// MARK: - 저장 버튼 UI 및 과목 저장 로직
private extension AddSubjectViewController {
    func setupSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.tintColor = .white
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: customColorScrollView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // 저장 버튼 클릭 시
    @objc func saveTapped() {
        // 이름, 색상 유효성 체크
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "입력 오류", message: "과목 이름을 입력해주세요.")
            return
        }
        guard let selectedColor = selectedColor else {
            showAlert(title: "색상 선택", message: "색상을 선택해주세요.")
            return
        }
        // CoreData에 새로운 StudySubject 객체 생성 후 저장
        let context = CoreDataStack.shared.context
        let newSubject = StudySubject(context: context)
        newSubject.name = name
        newSubject.colors = [selectedColor] as NSObject
        newSubject.primaryColorHex = selectedColor as NSObject
        newSubject.createdAt = Date()
        let fetchRequest: NSFetchRequest<StudySubject> = StudySubject.fetchRequest()
        if let count = try? context.count(for: fetchRequest) {
            newSubject.sortIndex = Int64(count)
        }
        do {
            try context.save()
            delegate?.didAddSubject() // 과목 추가 이벤트 알림
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "저장 실패", message: "과목을 저장하지 못했습니다.")
        }
    }
    
    // 간단한 UIAlert 표시 함수
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIColor HEX 변환/생성 편의 확장
extension UIColor {
    // UIColor → HEX 문자열로 변환
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else { return "#000000" }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    // HEX 문자열 → UIColor
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
