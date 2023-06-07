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
    
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User ,completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        let quary = COLLECTION_USERS
            .whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge)
            .whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
        
        quary.getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionary: dictionary)
                
                guard user.uid != Auth.auth().currentUser?.uid else { return }
                users.append(user)
                
                //해당 유저 빼므로 -1
                if users.count == snapshot.documents.count - 1 {
                    completion(users)
                }
            })
        }
    }
    
    static func saveUserData(user: User, completion: @escaping (Error?) -> Void) {
        let data = ["uid": user.uid,
                    "fullName": user.name,
                    "imageUrls": user.imageUrls,
                    "age": user.age,
                    "bio": user.bio,
                    "profession": user.profession,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String: Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
                    
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
        
    }
    
    static func checkIfMatchExists(forUser user: User, Completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            Completion(didMatch)
        }
    }
    
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
    

    
}
