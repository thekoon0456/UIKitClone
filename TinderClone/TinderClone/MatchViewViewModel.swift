//
//  MatchViewViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/07.
//

import Foundation

struct MatchViewViewModel {
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String

    var currentUserImageUrl: URL?
    var matchedUserImageUrl: URL?
    
    init(currentUser: User, matchedUser: User) {
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have liked each other!"
        
        guard let imageUrlString = currentUser.imageUrls.first else { return }
        guard let matchedImageUrlString = matchedUser.imageUrls.first else { return }
        
        currentUserImageUrl = URL(string: imageUrlString)
        matchedUserImageUrl = URL(string: matchedImageUrlString)
        
    }
}
