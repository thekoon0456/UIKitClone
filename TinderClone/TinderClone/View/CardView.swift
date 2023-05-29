//
//  CardView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit

class CardView: UIView {
    
    //MARK: - Properties
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
        
        configureGestureRecognizers()
        
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
        let translation = sender.translation(in: nil)
        //DEBUG로 filter 검색 가능
        switch sender.state {
        case .began:
            print("DEBUG: Pan did begin...")
        case .changed:
            let degrees: CGFloat = translation.x / 20
            let angle = degrees * .pi / 180
            let rotaionalTransform = CGAffineTransform(rotationAngle: angle)
            self.transform = rotaionalTransform.translatedBy(x: translation.x, y: translation.y)
        case .ended:
            print("DEBUG: Pan  ended...")
        default: break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        print("DEBUG: Did tap in photo...")
    }
    
    //MARK: - Helpers
    
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
