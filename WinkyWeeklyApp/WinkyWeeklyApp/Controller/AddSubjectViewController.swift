//
//  AddSubjectViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//

import UIKit
import CoreData


// ✅ 1. 델리게이트 프로토콜 정의 - 과목 저장 후 알림용
protocol AddSubjectViewControllerDelegate: AnyObject {
    func didAddSubject()
}
    
final class AddSubjectViewController: UIViewController {

    
    // MARK: - Delegate
    // ✅ 3. 델리게이트 선언 (외부에 알리기 위함)
    weak var delegate: AddSubjectViewControllerDelegate?


    // MARK: - UI 요소
    private let nameTextField = UITextField()                  // 과목명 입력 필드
    private let colorStackView = UIStackView()                 // 색상 버튼들을 담을 스택뷰
    private let saveButton = UIButton(type: .system)           // 저장
    
    
    // ✅ 4. 상태 저장
//    private var selectedColors: [String] = []                  // 선택된 색상 목록 (최대 5개)
    private var selectedColor: String?
    private var selectedButton: UIButton? // 이전 버튼 추적
    
    // 샘플 팔레트 색상들 (hex 문자열)
    private let availableColors: [String] = ["#FF5E5E", "#FFB72B", "#4DD091", "#59AFFF", "#AA8DFF", "#FF87E2", "#7C7C7C"]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "과목 추가" // ✅ 네비게이션 바에 표시될 제목
        setupUI() // 기존 setup 함수들 정리해서 호출
//        setupNameTextField()
//        setupColorPalette()
//        setupSaveButton()
    }
    
    // MARK: - UI 초기화 전체 호출 함수
    private func setupUI() {
        setupNameTextField()     // 과목명 입력창
        setupColorPalette()      // 색상 선택 팔레트
        setupSaveButton()        // 저장 버튼
//        setupNavigationClose()   // ← 닫기 버튼 추가했을 경우
    }
    // MARK: - 이름 입력 필드
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
    
    // MARK: - 색상 팔레트 UI 설정
        private func setupColorPalette() {
            colorStackView.axis = .horizontal
            colorStackView.spacing = 12
            colorStackView.distribution = .fillEqually
            colorStackView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(colorStackView)

            // ✅ 색상 버튼 생성 및 스택뷰에 추가
            for hex in availableColors {
                let button = UIButton(type: .custom)
                button.backgroundColor = UIColor(hex: hex)
                button.layer.cornerRadius = 16
                button.layer.borderColor = UIColor.darkGray.cgColor
                button.layer.borderWidth = 0
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 32).isActive = true
                button.accessibilityIdentifier = hex
                button.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)
                colorStackView.addArrangedSubview(button)
            }

            NSLayoutConstraint.activate([
                colorStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
                colorStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                colorStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }


    // MARK: - 저장 버튼 UI 설정
    private func setupSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        saveButton.tintColor = .white
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: colorStackView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - 색상 버튼 클릭 시 동작
    @objc private func colorTapped(_ sender: UIButton) {
        guard let hex = sender.accessibilityIdentifier else { return }

//        if selectedColors.contains(hex) {
//            selectedColors.removeAll { $0 == hex }
//            sender.layer.borderWidth = 0
//        } else {
//            guard selectedColors.count < 5 else { return } // ✅ 5개 이상 선택 금지
//            selectedColors.append(hex)
//            sender.layer.borderWidth = 3
//        }
        // 이전 선택 제거
        selectedButton?.layer.borderWidth = 0

        // 새 선택 적용
        selectedColor = hex
        sender.layer.borderWidth = 3
        selectedButton = sender
    }


    // MARK: - 저장 버튼 동작
//    @objc private func saveTapped() {
//        // ✅ 입력 유효성 체크
//        guard let name = nameTextField.text, !name.isEmpty else {
//            showAlert(title: "입력 오류", message: "과목 이름을 입력해주세요.")
//            return
//        }
//
//        guard !selectedColors.isEmpty else {
//            showAlert(title: "색상 선택", message: "색상을 1개 이상 선택해주세요.")
//            return
//        }
//
//        // ✅ CoreData 저장 로직
//        let context = CoreDataStack.shared.context
//        let newSubject = Subject(context: context)
//        newSubject.name = name
//        newSubject.colors = selectedColors as NSObject
//        newSubject.primaryColorHex = selectedColors.first as? NSObject
//        newSubject.createdAt = Date()
//
//        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
//        if let count = try? context.count(for: fetchRequest) {
//            newSubject.sortIndex = Int64(count)
//        }
//
//        do {
//            try context.save()
//            delegate?.didAddSubject() // ✅ 델리게이트 호출로 목록 갱신 유도
//            dismiss(animated: true)
//        } catch {
//            showAlert(title: "저장 실패", message: "과목을 저장하지 못했습니다.")
//        }
//    }
    @objc private func saveTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "입력 오류", message: "과목 이름을 입력해주세요.")
            return
        }

        guard let selectedColor = selectedColor else {
            showAlert(title: "색상 선택", message: "색상을 선택해주세요.")
            return
        }

        // ✅ Core Data 저장
        let context = CoreDataStack.shared.context
        let newSubject = Subject(context: context)
        newSubject.name = name
        newSubject.colors = [selectedColor] as NSObject
        newSubject.primaryColorHex = selectedColor as NSObject
        newSubject.createdAt = Date()

        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        if let count = try? context.count(for: fetchRequest) {
            newSubject.sortIndex = Int64(count)
        }
        do {
                try context.save()
                delegate?.didAddSubject()

                // ✅ 기존 모달 닫기 방식 ❌
                // dismiss(animated: true)

                // ✅ push 방식에 맞는 뒤로가기
                navigationController?.popViewController(animated: true)
            } catch {
                showAlert(title: "저장 실패", message: "과목을 저장하지 못했습니다.")
            }
    }
    // MARK: - 경고창
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    func canSaveSubject(name: String?, selectedColors: [String]) -> Bool {
        guard let name = name, !name.isEmpty else { return false }
        return !selectedColors.isEmpty
    }
}



// MARK: - HEX 코드 → UIColor 변환
// HEX 문자열로부터 UIColor를 생성하는 확장
extension UIColor {
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
