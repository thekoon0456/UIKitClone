//
//  MatchView.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/07.
//

import UIKit

class MatchView: UIView {
    
    private let currentUser: User
    private let matchUser: User
    
    init(currentUser: User, matchUser: User) {
        self.currentUser = currentUser
        self.matchUser = matchUser
        super.init(frame: .zero)
        
        backgroundColor = .red
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
