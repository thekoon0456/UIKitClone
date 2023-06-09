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
    var imageUrls: [String]
    var profession: String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String
    
    //firebase에서 키-값으로 구성된 데이터 받아오기. 딕셔너리로 구성
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.imageUrls = dictionary["imageUrls"] as? [String] ?? [String]()
        self.profession = dictionary["profession"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 60
        self.bio = dictionary["bio"] as? String ?? ""
    }

}
