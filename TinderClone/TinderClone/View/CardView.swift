//
//  CardView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    //MARK: - Properties
    private let viewModel: CardViewModel
    
    //클래스 여러 위치에서 엑세스
    private let gradientLayer = CAGradientLayer()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        return iv
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        
        let attributedText = NSMutableAttributedString(string: "Jane Doe", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor : UIColor.white])
        
        attributedText.append(NSMutableAttributedString(string: "  20", attributes: [.font : UIFont.systemFont(ofSize: 28), .foregroundColor : UIColor.white]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
        imageView.image = viewModel.user.images.first
        
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        //순서 중요. gradient 위에 label 올리기
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right: rightAnchor, paddingRight: 16)
        
    }
    
    //layout이 따로 없고 상위 뷰에만 있는 상황. frame 접근하도도록
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {

        //DEBUG로 filter 검색 가능
        switch sender.state {
        case .began:
            superview?.subviews.forEach { $0.layer.removeAllAnimations() } 
            print("DEBUG: Pan did begin...")
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        print("DEBUG: Did tap in photo...")
    }
    
    //MARK: - Helpers
    
    func panCard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotaionalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotaionalTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        //스와이프 방향
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        //카드 넘길지 판단. x절대값이 100 넘으면 넘김
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            if shouldDismissCard {
                let xTranslation = CGFloat(direction.rawValue) * 1000 //x로 1000픽셀 만큼 이동
                let offScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = offScreenTransform
                self.removeFromSuperview()
            } else {
                self.transform = .identity
            }

            print("DEBUG: Animation did complete...")
        }
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
    }
    
}
