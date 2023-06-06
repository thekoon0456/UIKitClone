//
//  BottomControlsStackView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit

//하위클래스에 있음. 프로토콜 만들고 delegate사용
//하위 클래스에서 컨트롤러로 작업 위임
protocol BottomControlsStackViewDelegate: AnyObject {
    func handleLike()
    func handleDislike()
    func handleRefresh()
}

class BottomControlsStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let superlikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    let boostButton = UIButton(type: .system)
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        distribution = .fillEqually
        
        refreshButton.setImage(UIImage(named: "refresh_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(UIImage(named: "dismiss_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(UIImage(named: "super_like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(UIImage(named: "like_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(UIImage(named: "boost_circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        [refreshButton, dislikeButton, superlikeButton, likeButton, boostButton].forEach { view in
            addArrangedSubview(view)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        delegate?.handleRefresh()
    }
    
    @objc func handleDislike() {
        delegate?.handleDislike()
    }
    
    @objc func handleLike() {
        delegate?.handleLike()
    }
    
}
