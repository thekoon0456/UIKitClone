//
//  MatchView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/07.
//

import UIKit

class MatchView: UIView {
    
    //MARK: -  Properties
    
    private let currentUser: User
    private let matchUser: User
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "You and Megan have liked each other!"
        return label
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane3"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let matchedUserImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var keepSwipingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapKeepSwiping), for: .touchUpInside)
        return button
    }()
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]
    
    //MARK: - Lifecycle
    
    init(currentUser: User, matchUser: User) {
        self.currentUser = currentUser
        self.matchUser = matchUser
        super.init(frame: .zero)
        
        configureBlurView()
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func didTapSendMessage() {
        
    }
    
    @objc func didTapKeepSwiping() {
        
    }
    
    @objc func handelDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    //MARK: - Helpers
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 1 //투명으로 시작. 나중에 나오도록 애니메이션
        }
        
        currentUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 140 / 2
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 48, paddingRight: 48)
        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
    }
    
    func configureBlurView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelDismissal))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0 //처음에 투명으로 시작
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.visualEffectView.alpha = 1
        }
    }
    
}
