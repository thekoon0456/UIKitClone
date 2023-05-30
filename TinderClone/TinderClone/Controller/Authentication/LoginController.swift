//
//  LoginController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/29.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate) //색상변경 가능
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeHolder: "Email")
    
    private let passwordTextField = CustomTextField(placeHolder: "Password", isSecureTextEntry: true)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
//        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black //뷰컨트롤러가 아니라 네비게이션바 안에 있음.
        setupGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 100)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop:0)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
    }
    
    func setupGradientLayer() {
        let topColor = #colorLiteral(red: 0.9067020416, green: 0.3099078834, blue: 0.352029562, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8937748671, green: 0.006600689609, blue: 0.4452003241, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
}
