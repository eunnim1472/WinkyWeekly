//
//  CalendarCell.swift
//  WinkyWeeklyApp
//
//  Created by 김가은 on 5/22/25.
//

// CalendarCell.swift

import UIKit

final class CalendarCell: UICollectionViewCell {
    
    let label = UILabel()
    let circleView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(circleView)
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 32),
            circleView.heightAnchor.constraint(equalToConstant: 32),
            
            label.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
        
        circleView.layer.cornerRadius = 16
        circleView.clipsToBounds = true
    }

    // ✅ 공통 스타일 적용용 메서드
    func configure(date: Date, isToday: Bool, isSelected: Bool, isInMonth: Bool) {
        let day = Calendar.current.component(.day, from: date)
        label.text = "\(day)"

        if isToday {
            circleView.backgroundColor = UIColor.systemBlue
            label.textColor = .white
        } else if isSelected {
            circleView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            label.textColor = UIColor.systemBlue
        } else {
            circleView.backgroundColor = .clear
            label.textColor = isInMonth ? .label : .lightGray
        }
    }
}
