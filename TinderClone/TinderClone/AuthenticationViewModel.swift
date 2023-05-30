//
//  AuthenticationViewModel.swift
//  TinderClone
//
//  Created by Deokhun KIM on 2023/05/30.
//

import Foundation

//연관된 두개의 뷰모델을 Authentication 프로토콜로 구현
protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel {
    //let으로 선언하면 옵셔널로 만들어도 초기화시 값을 전달해야함!
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        password?.isEmpty == false
    }
}

struct RegistrationViewModel {
    //let으로 선언하면 옵셔널로 만들어도 초기화시 값을 전달해야함!
    var email: String?
    var fullName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false &&
        fullName?.isEmpty == false &&
        password?.isEmpty == false
    }
}
