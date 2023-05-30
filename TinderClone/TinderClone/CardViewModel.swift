//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/29.
//

import UIKit

class CardViewModel {
    
    let user: User
    
    let userInfoText: NSAttributedString
    private var imageIndex = 0
    lazy var imageToShow = user.images.first
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor : UIColor.white])
        
        attributedText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 28), .foregroundColor : UIColor.white]))
        
        userInfoText = attributedText
    }
    
    func shouldNextPhoto() {
        //index guard 사용해 범위 내로 
        guard imageIndex < user.images.count - 1 else { return }
        imageIndex += 1
        self.imageToShow = user.images[imageIndex]
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        self.imageToShow = user.images[imageIndex]
    }
}
