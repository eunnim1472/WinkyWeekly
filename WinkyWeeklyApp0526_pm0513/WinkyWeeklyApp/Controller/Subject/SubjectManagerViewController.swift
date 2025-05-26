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
//        private let scrollView = UIScrollView()
//        private let subjectsStackView = UIStackView()
    
    /// 과목 목록을 표시할 테이블뷰
        private let tableView = UITableView()  // [Diff] scrollView, subjectsStackView 제거 → tableView 추가
        
    
    // MARK: - Data
    
    /// Core Data에서 불러온 StudySubject 객체 배열
    private var subjects: [StudySubject] = []  // [Diff] subjectsStackView 대신 데이터 저장용 배열 추가

        // MARK: - Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            title = "과목 목록"
            
            // [Diff] setupScrollView() 제거 → setupTableView() 호출
            
            setupTableView()   // [Diff] 목록 UI 세팅
            loadSubjects()     // [Diff] Core Data에서 데이터 불러오기

            // [Diff] 네비게이션 바 오른쪽에 + 버튼 추가, addSubjectTapped 연결
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(addSubjectTapped)
            )
        }

//    // MARK: - ScrollView & StackView 설정
//    private func setupScrollView() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//
//        subjectsStackView.axis = .vertical
//        subjectsStackView.spacing = 12
//        subjectsStackView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(subjectsStackView)
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            subjectsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
//            subjectsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            subjectsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
//            subjectsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            subjectsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
//        ])
//    }
//

    
    // MARK: - TableView 설정
    
    /// 테이블뷰를 뷰 계층에 추가하고, 제약조건·데이터소스·델리게이트를 설정합니다.
    private func setupTableView() {
        view.addSubview(tableView)  // [Diff] scrollView 대신 tableView 추가
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self   // [Diff] 스택뷰 대신 데이터소스 지정
        tableView.delegate = self     // [Diff] 델리게이트 지정
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubjectCell")
        // 기존 UITableViewCell 대신 커스텀 셀 등록
            tableView.register(SubjectTableViewCell.self, forCellReuseIdentifier: "SubjectCell")
    }

    // MARK: - 과목 불러오기
    
    /// Core Data에서 StudySubject를 fetch하여 배열에 저장한 뒤 테이블뷰를 갱신합니다.
    private func loadSubjects() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<StudySubject> = StudySubject.fetchRequest()  // [Diff] Subject → StudySubject
        request.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
        
        do {
            subjects = try context.fetch(request)
            tableView.reloadData()  // [Diff] 스택뷰에 add 대신 테이블뷰 reload
        } catch {
            print("❌ 과목 불러오기 실패: \(error)")
        }
    }
//    // MARK: - 과목 불러오기 및 UI 추가
//    private func loadSubjects() {
//        subjectsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 제거
//
//        let context = CoreDataStack.shared.context
//        // 기존
////        let request: NSFetchRequest<Subject> = Subject.fetchRequest()
//        // 변경
//        let request: NSFetchRequest<StudySubject> = StudySubject.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "sortIndex", ascending: true)]
//
//        if let subjects = try? context.fetch(request) {
//            for subject in subjects {
//                let subjectRow = createSubjectRow(for: subject) // ✅ UIView로 과목행 생성
//                subjectsStackView.addArrangedSubview(subjectRow)
//            }
//        }
//
//        setupAddSubjectButton() // 가장 마지막에 + 버튼 추가
//    }

    
//    // MARK: - 과목 1개에 대한 행 생성
//    private func createSubjectRow(for subject: StudySubject) -> UIView {
//        let container = UIStackView()
//        container.axis = .horizontal
//        container.spacing = 8
//        container.alignment = .center
//        container.distribution = .equalSpacing
//        container.translatesAutoresizingMaskIntoConstraints = false
//
//        // 과목 이름
//        let nameLabel = UILabel()
//        nameLabel.text = subject.name
//        nameLabel.font = .systemFont(ofSize: 16)
//
//        // 삭제 버튼
//        let deleteButton = UIButton(type: .system)
//        deleteButton.setTitle("삭제", for: .normal)
//        deleteButton.setTitleColor(.systemRed, for: .normal)
//        deleteButton.addAction(UIAction(handler: { [weak self] _ in
//            self?.confirmDelete(subject: subject)
//        }), for: .touchUpInside)
//
//        container.addArrangedSubview(nameLabel)
//        container.addArrangedSubview(deleteButton)
//
//        return container
//    }


//    // MARK: - 추가 버튼
//    private func setupAddSubjectButton() {
//        let addButton = UIButton(type: .system)
//        addButton.setTitle("+ 과목 추가", for: .normal)
//        addButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
//        addButton.tintColor = .systemBlue
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        addButton.addTarget(self, action: #selector(addSubjectTapped), for: .touchUpInside)
//
//        subjectsStackView.addArrangedSubview(addButton)
//    }

    // MARK: - 과목 추가 화면으로 전환
    @objc private func addSubjectTapped() {
        let addVC = AddSubjectViewController()
        addVC.delegate = self // ✅ 델리게이트 연결
        
//        let nav = UINavigationController(rootViewController: addVC) // ✅ 네비게이션으로 감싸기
        // ✅ 기존 모달 방식 → ❌
//        present(nav, animated: true)
//        
//        // ✅ push 방식으로 변경
//            navigationController?.pushViewController(addVC, animated: true)
        navigationController?.pushViewController(addVC, animated: true)  // [Diff] 모달 → push
        // [Diff] 기존 tableView footer의 addButton이 호출하던 메서드를 네비게이션 바 버튼에서도 동일하게 사용
    }
    
    // MARK: - CoreData 삭제
    private func deleteSubject(_ subject: StudySubject) {
        let context = CoreDataStack.shared.context
        context.delete(subject)

        do {
            try context.save()
            loadSubjects() // [Diff] 삭제 후 테이블뷰 새로고침
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }
    // MARK: - 삭제 확인 경고창
    private func confirmDelete(subject: StudySubject) {
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

// MARK: - UITableViewDataSource

extension SubjectManagerViewController: UITableViewDataSource {
    /// 셀 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    /// 각 셀 구성: 과목 이름과 삭제 액션
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as? SubjectTableViewCell else {
            return UITableViewCell()
        }
        let subject = subjects[indexPath.row]
        cell.configure(subject: subject)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SubjectManagerViewController: UITableViewDelegate {
    /// 스와이프 삭제 기능 구현
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subjectToDelete = subjects[indexPath.row]
            confirmDelete(subject: subjectToDelete)
        }
    }
    /// 편집화면
    ///  // [Diff] 셀 터치 시 편집 화면으로 push
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let subject = subjects[indexPath.row] // [Diff] 선택된 과목 가져오기
            let editVC = EditSubjectViewController(subject: subject) // [Diff] 생성자에 주입
            editVC.delegate = self // [Diff] 목록 갱신 위함
            navigationController?.pushViewController(editVC, animated: true) // [Diff] push 이동
        }

    
}

// MARK: - AddSubjectViewControllerDelegate

extension SubjectManagerViewController: AddSubjectViewControllerDelegate {
    /// 과목 추가 완료 시 호출되어 목록을 갱신합니다.
    func didAddSubject() {
        loadSubjects()  // [Diff] 스택뷰 대신 테이블뷰 갱신
    }
}

// SubjectManagerViewController.swift
extension SubjectManagerViewController: EditSubjectViewControllerDelegate {
    func didUpdateSubject() {
        loadSubjects() // 편집 후 목록 갱신
    }
}
