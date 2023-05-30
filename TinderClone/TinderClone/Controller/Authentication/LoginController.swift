//
//  LoginController.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/29.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate) //색상변경 가능
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeHolder: "Email")
    private let passwordTextField = CustomTextField(placeHolder: "Password", isSecureTextEntry: true)
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(title: "Log In", type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?   ", attributes: [.foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.foregroundColor: UIColor.white,
                                                                                  .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFieldObservers()
    }
    
    //MARK: - Actions
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleLogin() {
        navigationController?.pushViewController(HomeController(), animated: true)
    }
    
    @objc func handleShowRegistration() {
        navigationController?.pushViewController(RegistrationController(), animated: true)
    }
    
    //MARK: - Helpers
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        } else {
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true //상단에 돌아가기버튼 없앰
        navigationController?.navigationBar.barStyle = .black //뷰컨트롤러가 아니라 네비게이션바 안에 있음.
        configureGradientLayer()
        
        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 100)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop:24)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16

        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
    }
    
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

extension LoginController {
    
}
