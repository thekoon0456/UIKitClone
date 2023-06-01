//
//  User.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/29.
//

import UIKit

struct User {
    //사용자가 사용하면서 변경할 수 있는것만 var로
    var name: String
    var age: Int
    let email: String
    let uid: String
    let profileImageUrl: String
//    var images: [UIImage]
    
    //firebase에서 키-값으로 구성된 데이터 받아오기. 딕셔너리로 구성
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileImageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}
