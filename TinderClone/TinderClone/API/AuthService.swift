//
//  AuthService.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/30.
//

//API 연결 코드
//뷰컨트롤러와 분리시켜 관리

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

//인증
struct AuthService {
    
    static func logUserIn(withEmail email: String, password: String, complition: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: complition)
    }
    
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
        
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error {
                    print("DEBUG: 사용자 등록 에러. \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "fullName": credentials.fullname,
                            "imageUrls": [imageUrl],
                            "uid": uid,
                            "age": 10] as [String : Any]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }

        }
        
    }
    
}
