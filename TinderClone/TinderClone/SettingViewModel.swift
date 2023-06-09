//
//  SettingViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/06/02.
//

import Foundation

enum SettingSections: Int, CaseIterable {
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
    
    private let user: User
    let section: SettingSections
    
    let placeHolderText: String
    var value: String?
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    func minAgeLabelText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLabelText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
    var minAgeSliderValue: Float {
        return Float(user.minSeekingAge)
    }
    
    var maxAgeSliderValue: Float {
        return Float(user.maxSeekingAge)
    }
    
    init(user: User, section: SettingSections) {
        self.user = user
        self.section = section
        placeHolderText = "Enter \(section.description.lowercased())"
        
        switch section {
        case .name:
            value = user.name
        case .profession:
            value = user.profession
        case .age:
            value = "\(user.age)"
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
}
