//
//  Service.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/30.
//

import UIKit
import Firebase

//뷰컨과 분리해서 API 읽기, 쓰기.
struct Service {
    
    static func uploadImage(image: UIImage, complition: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        
        ref.putData(imageData) { metaData, error in
            if let error = error {
                print("DEBUG: 이미지 업로딩 에러. \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                complition(imageUrl)
            }
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
}
