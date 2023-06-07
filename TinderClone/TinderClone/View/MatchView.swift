//
//  MatchView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/07.
//

import UIKit

protocol MatchViewDelegate: AnyObject {
    func matchView(_ view: MatchView, wantsToSendMessageTo user: User)
}

class MatchView: UIView {
    
    //MARK: -  Properties
    
    private let viewModel: MatchViewViewModel
    weak var delegate: MatchViewDelegate?
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = viewModel.matchLabelText
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
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var keepSwipingButton: UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
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
    
    init(viewModel: MatchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        loadUserData()
        
        configureBlurView()
        configureUI()
        configureAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func didTapSendMessage() {
        delegate?.matchView(self, wantsToSendMessageTo: viewModel.matchedUser)
    }
    
    @objc func handelDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    //MARK: - Helpers
    
    func loadUserData() {
        descriptionLabel.text = viewModel.matchLabelText
        
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageUrl)
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImageUrl)
    }
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 0 //투명으로 시작. 나중에 나오도록 애니메이션
        }
        
        currentUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 140 / 2
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48, paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 48, paddingRight: 48)
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        
        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
    }
    
    func configureAnimations() {
        views.forEach { $0.alpha = 1 }
        
        let angle = 30 * CGFloat.pi / 180 // 처음에 휘어진 각도 설정
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0)) //x로 200포인트 이동
        
        //매치 유저는 반대쪽에서 반대로 옴
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        //animateKeyframes: 여러 애니메이션 연결. 전체적으로 1.3초
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic) {
            //0초에서 시작
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                //CGAffineTransform(rotationAngle:) 회전효과
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            //0.6초에서 시작
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                //원래 설정한 포지션으로
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity
            }
        }
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }
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
