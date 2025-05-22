//
//  SubjectManagerViewController.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//
import UIKit
import CoreData

final class SubjectManagerViewController: UIViewController {

    // MARK: - UI
        private let scrollView = UIScrollView()
        private let subjectsStackView = UIStackView()

        // MARK: - Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            title = "과목 목록"
            setupScrollView()
            loadSubjects()
        }

    // MARK: - ScrollView & StackView 설정
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        subjectsStackView.axis = .vertical
        subjectsStackView.spacing = 12
        subjectsStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(subjectsStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            subjectsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            subjectsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            subjectsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            subjectsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            subjectsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }


    // MARK: - 과목 불러오기 및 UI 추가
    private func loadSubjects() {
        subjectsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 제거

        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Subject> = Subject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]

        if let subjects = try? context.fetch(request) {
            for subject in subjects {
                let subjectRow = createSubjectRow(for: subject) // ✅ UIView로 과목행 생성
                subjectsStackView.addArrangedSubview(subjectRow)
            }
        }

        setupAddSubjectButton() // 가장 마지막에 + 버튼 추가
    }

    
    // MARK: - 과목 1개에 대한 행 생성
    private func createSubjectRow(for subject: Subject) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        container.distribution = .equalSpacing
        container.translatesAutoresizingMaskIntoConstraints = false

        // 과목 이름
        let nameLabel = UILabel()
        nameLabel.text = subject.name
        nameLabel.font = .systemFont(ofSize: 16)

        // 삭제 버튼
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.confirmDelete(subject: subject)
        }), for: .touchUpInside)

        container.addArrangedSubview(nameLabel)
        container.addArrangedSubview(deleteButton)

        return container
    }


    // MARK: - 추가 버튼
    private func setupAddSubjectButton() {
        let addButton = UIButton(type: .system)
        addButton.setTitle("+ 과목 추가", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        addButton.tintColor = .systemBlue
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addSubjectTapped), for: .touchUpInside)

        subjectsStackView.addArrangedSubview(addButton)
    }

    // MARK: - 과목 추가 화면으로 전환
    @objc private func addSubjectTapped() {
        let addVC = AddSubjectViewController()
        addVC.delegate = self // ✅ 델리게이트 연결
        
//        let nav = UINavigationController(rootViewController: addVC) // ✅ 네비게이션으로 감싸기
        // ✅ 기존 모달 방식 → ❌
//        present(nav, animated: true)
        
        // ✅ push 방식으로 변경
            navigationController?.pushViewController(addVC, animated: true)
    }
    
    // MARK: - CoreData 삭제
    private func deleteSubject(_ subject: Subject) {
        let context = CoreDataStack.shared.context
        context.delete(subject)

        do {
            try context.save()
            loadSubjects() // 삭제 후 목록 새로고침
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }
    // MARK: - 삭제 확인 경고창
    private func confirmDelete(subject: Subject) {
        let alert = UIAlertController(
            title: "삭제 확인",
            message: "'\(subject.name ?? "과목")'을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { _ in
            self.deleteSubject(subject)
        }))
        present(alert, animated: true)
    }

    
}
// MARK: - AddSubjectViewControllerDelegate
extension SubjectManagerViewController: AddSubjectViewControllerDelegate {
    func didAddSubject() {
        loadSubjects() // ✅ 과목 추가 후 목록 다시 불러오기
    }
}
