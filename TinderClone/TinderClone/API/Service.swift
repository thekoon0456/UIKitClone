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
    
    //MARK: - Fetching
    
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
        
        fetchSwipes { swipedUserIDs in
            quary.getDocuments { snapshot, error in
                guard let snapshot = snapshot else { return }
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return } //swipe 했는지 확인
                    users.append(user)
                    
                    //해당 유저 빼므로 -1
//                    if users.count == snapshot.documents.count - 1 {
//                        completion(users)
//                    }
                })
                //completion block내, forEach문 밖으로 꺼내서 한번만 실행되도록
                completion(users)
            }
        }
    }
    
    private static func fetchSwipes(completion: @escaping ([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            
            completion(data)
        }
    }
    
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { snapshop, error in
            guard let data = snapshop else { return }
        
            let matches = data.documents.map { Match(dictionary: $0.data()) }
            completion(matches)
        }
    }
    
    //MARK: - Uploads
    
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
    
    //각 사용자의 구조에 각각 데이터 업로드. 사용자에 대한 모든 매치 정보 저장
    static func uploadMatch(currentUser: User, matchedUser: User) {
        guard let profileImageUrl = matchedUser.imageUrls.first else { return }
        guard let currentUserProfileImageUrl = currentUser.imageUrls.first else { return }
        
        let matchedUserData = ["uid": matchedUser.uid,
                               "name": matchedUser.name,
                               "profileImageUrl": profileImageUrl]
        
        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches").document(matchedUser.uid).setData(matchedUserData)
        
        let currentUserData = ["uid": currentUser.uid,
                               "name": currentUser.name,
                               "profileImageUrl": currentUserProfileImageUrl]
        
        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
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
