//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/29.
//

import UIKit

class CardViewModel {
    
    let user: User
    let imageUrls: [String]
    let userInfoText: NSAttributedString
    private var imageIndex = 0
    var index: Int { return imageIndex } //이미지 인덱스 외부에서 수정 안하고 접근만 하도록
    var imageUrl: URL?
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy),
                                                                    .foregroundColor : UIColor.white])
        
        attributedText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 28), .foregroundColor : UIColor.white]))
        
        userInfoText = attributedText
        
        self.imageUrls = user.imageUrls
        self.imageUrl = URL(string: self.imageUrls[0])
    }
    
    func shouldNextPhoto() {
//        //index guard 사용해 범위 내로 
        guard imageIndex < user.imageUrls.count - 1 else { return }
        imageIndex += 1
        imageUrl = URL(string: imageUrls[imageIndex])
    }
//    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageUrl = URL(string: imageUrls[imageIndex])
    }
}
