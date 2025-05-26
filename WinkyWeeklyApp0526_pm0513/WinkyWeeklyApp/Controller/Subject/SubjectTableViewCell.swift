//
//  SubjectTableViewCell.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/26/25.
//

import UIKit

import UIKit

class SubjectTableViewCell: UITableViewCell {
    let colorBadgeView = UIView()
    let nameLabel = UILabel()
    
    // [Diff] 셀 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // [Diff] UI 구성 메서드
    private func setupViews() {
        // 원형 뱃지
        colorBadgeView.translatesAutoresizingMaskIntoConstraints = false
        colorBadgeView.layer.cornerRadius = 14
        colorBadgeView.layer.masksToBounds = false
        colorBadgeView.layer.borderWidth = 2
        colorBadgeView.layer.borderColor = UIColor.systemGray4.cgColor  // 기본 테두리
        // 그림자 효과
        colorBadgeView.layer.shadowColor = UIColor.black.cgColor
        colorBadgeView.layer.shadowOpacity = 0.10
        colorBadgeView.layer.shadowOffset = CGSize(width: 0, height: 1)
        colorBadgeView.layer.shadowRadius = 2
        
        contentView.addSubview(colorBadgeView)
        NSLayoutConstraint.activate([
            colorBadgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            colorBadgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorBadgeView.widthAnchor.constraint(equalToConstant: 28),
            colorBadgeView.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        // 과목명 라벨
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        nameLabel.textColor = .label
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: colorBadgeView.trailingAnchor, constant: 18),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // [Diff] 셀 선택 시 효과 없앰(깔끔하게)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // [Diff] 대표색상 애니메이션
    func configure(subject: StudySubject) {
        nameLabel.text = subject.name
        if let hex = subject.primaryColorHex as? String {
            let color = UIColor(hex: hex)
            // 애니메이션 적용 (색상 변경시 fade-in)
            UIView.transition(with: colorBadgeView, duration: 0.22, options: .transitionCrossDissolve, animations: {
                self.colorBadgeView.backgroundColor = color
                self.colorBadgeView.layer.borderColor = color.cgColor // 테두리도 동일하게
            })
        } else {
            UIView.transition(with: colorBadgeView, duration: 0.22, options: .transitionCrossDissolve, animations: {
                self.colorBadgeView.backgroundColor = UIColor.systemGray4
                self.colorBadgeView.layer.borderColor = UIColor.systemGray4.cgColor
            })
        }
    }
}

//class SubjectTableViewCell: UITableViewCell {
//    let colorBadgeView = UIView()
//    let nameLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    private func setupViews() {
//        // 색상 뱃지(원형)
//        colorBadgeView.translatesAutoresizingMaskIntoConstraints = false
//        colorBadgeView.layer.cornerRadius = 10
//        colorBadgeView.layer.masksToBounds = true
//        contentView.addSubview(colorBadgeView)
//        NSLayoutConstraint.activate([
//            colorBadgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            colorBadgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            colorBadgeView.widthAnchor.constraint(equalToConstant: 20),
//            colorBadgeView.heightAnchor.constraint(equalToConstant: 20),
//        ])
//        
//        // 과목명 라벨
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.font = .systemFont(ofSize: 16)
//        contentView.addSubview(nameLabel)
//        NSLayoutConstraint.activate([
//            nameLabel.leadingAnchor.constraint(equalTo: colorBadgeView.trailingAnchor, constant: 14),
//            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//        ])
//    }
//    
//    func configure(subject: StudySubject) {
//        nameLabel.text = subject.name
//        if let hex = subject.primaryColorHex as? String {
//            colorBadgeView.backgroundColor = UIColor(hex: hex)
//        } else {
//            colorBadgeView.backgroundColor = UIColor.systemGray4
//        }
//    }
//}
