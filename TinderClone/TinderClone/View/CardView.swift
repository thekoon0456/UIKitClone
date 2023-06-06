//
//  CardView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit
import SDWebImage

//view에는 메서드 넣지말고 뷰만 넣기. delegate로 위임

enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

protocol CardViewDelegate: AnyObject {
    func cardView(_ view: CardView, wantsToShowProfileFor user: User)
    func cardView(_ view: CardView, didLikeUser: Bool)
}

class CardView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CardViewDelegate?
    
    let viewModel: CardViewModel
    
    //클래스 여러 위치에서 엑세스
    private let gradientLayer = CAGradientLayer()
    private lazy var barStackView = SegmentBarView(numberOfSegments: viewModel.imageUrls.count)

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "jane3")
        return iv
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = viewModel.userInfoText //내부가 아닌 viewModel에 접근. 인스턴스 만들어질때 초기화가 안되어있음. lazy var로 선언하면 viewModel이 초기화된 뒤라서 접근 가능
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureGestureRecognizers()
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        //순서 중요. gradient 위에 label 올리기
        configureBarStackView()
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
    
    @objc func handleShowProfile() {
        delegate?.cardView(self, wantsToShowProfileFor: viewModel.user)
    }
    
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
    
    @objc func handleChangePhoto(sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
//
        if shouldShowNextPhoto {
            viewModel.shouldNextPhoto()
        } else {
            viewModel.showPreviousPhoto()
        }
        
        imageView.sd_setImage(with: viewModel.imageUrl)
        
        barStackView.setHighlighted(index: viewModel.index)
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
        } completion: { _ in
            if shouldDismissCard {
                let didLike = direction == .right
                self.delegate?.cardView(self, didLikeUser: didLike)
            }
        }
    }
    
    func configureBarStackView() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 4)
    }
    
    func configureGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
    
}
