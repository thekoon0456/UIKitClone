//
//  SettingViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/02.
//

import Foundation

enum SettingSection: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange
    
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .profession:
            return "Profession"
        case .age:
            return "Age"
        case .bio:
            return "Bio"
        case .ageRange:
            return "Seeking Age Range"
        }
    }
}

struct SettingViewModel {
    
}
