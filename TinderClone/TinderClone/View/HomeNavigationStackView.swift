//
//  HomeNavigationStack.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit

protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showMessages()
}

class HomeNavigationStackView: UIStackView {
    
    //MARK: - Properties
    
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let tinderIcon = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        tinderIcon.contentMode = .scaleAspectFit
        
        settingButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingButton, UIView(), tinderIcon, UIView(), messageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(handleShowMessages), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //뷰컨이 아니라서 present() 사용 못함. 프로토콜로 custom delegate 만들어서 작업 위임
    @objc func handleShowSettings() {
        delegate?.showSettings()
    }
    
    @objc func handleShowMessages() {
        delegate?.showMessages()
    }
}
