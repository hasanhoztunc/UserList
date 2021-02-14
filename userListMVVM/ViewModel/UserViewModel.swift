//
//  UserViewModel.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import Foundation
import RxDataSources

typealias UserItemSection = SectionModel<Int, UserViewPresentable>

protocol UserViewPresentable {
    var userId: Int { get }
    var userNameLastname: String { get }
    var userDateOfBirth:String { get }
    var userEmail: String { get }
    var userPhone: String { get }
    var userNote: String? { get }
}

struct UserViewModel: UserViewPresentable {
    
    var userId: Int
    var userNameLastname: String
    var userDateOfBirth: String
    var userEmail: String
    var userPhone: String
    var userNote: String?
}

extension UserViewModel {
    init(model: UserModel) {
        self.userId = model.userId
        self.userNameLastname = "\(model.userName) \(model.userLastName) "
        self.userDateOfBirth = model.userDateOfBirth
        self.userEmail = model.userEmail
        self.userPhone = model.userPhone
        self.userNote = model.userNote
    }
}

extension UserViewModel: Equatable {
    
    static func ==(lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return ((lhs.userEmail == rhs.userEmail) && (lhs.userPhone == rhs.userPhone))
    }
}

extension UserViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userEmail)
    }
}
