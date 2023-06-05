//
//  SegmentBarView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/05.
//

import UIKit

class SegmentBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = .barDeselectedColor
            addArrangedSubview(barView)
        }
        
        arrangedSubviews.first?.backgroundColor = .white
        spacing = 4
        distribution = .fillEqually
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlighted(index: Int) {
        arrangedSubviews.forEach { $0.backgroundColor = .barDeselectedColor }
        arrangedSubviews[index].backgroundColor = .white
    }
}

