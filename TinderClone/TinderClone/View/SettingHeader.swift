//
//  SettingHeader.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/01.
//

import UIKit

protocol SettingHeaderDelegate: AnyObject {
    func settingHeader(_ header: SettingHeader, didSelect index: Int)
}

class SettingHeader: UIView {
    
    //MARK: - Properties
    var buttons = [UIButton]()
    lazy var button1 = createButton(0)
    lazy var button2 = createButton(1)
    lazy var button3 = createButton(2)
    
    weak var delegate: SettingHeaderDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemGroupedBackground
        
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        
        addSubview(button1)
        button1.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2, button3])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    @objc func handleSelectPhoto(sender: UIButton) {
        print("사진 셀렉터")
        delegate?.settingHeader(self, didSelect: sender.tag)
    }
    
    //MARK: - Helpers
    
    func createButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        return button
    }
}
