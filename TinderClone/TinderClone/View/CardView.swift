//
//  CardView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/28.
//

import UIKit

class CardView: UIView {
    
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemPurple
        layer.cornerRadius = 10
//        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
