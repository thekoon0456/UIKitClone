//
//  ProfileViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/05.
//

import UIKit

struct ProfileViewModel {
    
    private let user: User
    
    let userDetailAttributedString: NSAttributedString
    let profession: String
    let bio: String
    
    var imageUrls: [URL] {
        return user.imageUrls.map { URL(string: $0)! }
    }
    
    var imageCount: Int {
        return user.imageUrls.count
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.name,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        attributedText.append(NSAttributedString(string: "   \(user.age)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        userDetailAttributedString = attributedText
        
        profession = user.profession
        bio = user.bio
    }
}
