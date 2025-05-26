//
//  EditSubjectViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/26/25.
//

// EditSubjectViewController.swift

import UIKit
import CoreData

protocol EditSubjectViewControllerDelegate: AnyObject {
    func didUpdateSubject()
}

final class EditSubjectViewController: UIViewController {

    private let subject: StudySubject   // [Diff] 편집 대상 과목
    
    // MARK: - Delegate
    weak var delegate: EditSubjectViewControllerDelegate?

    // MARK: - UI
    private let nameTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    // 필요시 색상 팔레트 등 추가
   
    // MARK: - 생성자
    init(subject: StudySubject) {
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "과목 편집"

        setupUI()
        loadSubjectInfo()
    }

    private func setupUI() {
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])

        saveButton.setTitle("저장", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // 기존 데이터 세팅
    private func loadSubjectInfo() {
        nameTextField.text = subject.name
        // 색상 등 필요시 추가
        
    }

    // 저장 버튼 동작
    @objc private func saveTapped() {
        guard let newName = nameTextField.text, !newName.isEmpty else {
            showAlert(title: "입력 오류", message: "과목 이름을 입력해주세요.")
            return
        }

        // Core Data 업데이트
        subject.name = newName
        // 색상 등 추가로 수정 가능

        do {
            try subject.managedObjectContext?.save()
            delegate?.didUpdateSubject() // 목록 갱신
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "저장 실패", message: "변경사항을 저장하지 못했습니다.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
