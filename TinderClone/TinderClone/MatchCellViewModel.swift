//
//  MatchCellViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/08.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    let profileImageUrl: URL?
    let uid: String
    
    init(match: Match) {
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid
    }
}
