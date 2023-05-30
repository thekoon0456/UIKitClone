//
//  CustomTextField.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/30.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeHolder: String, isSecureTextEntry: Bool? = false) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        keyboardAppearance = .dark
        
        borderStyle = .none
        textColor = .white
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        self.isSecureTextEntry = isSecureTextEntry ?? false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
