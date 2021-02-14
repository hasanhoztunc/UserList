//
//  User.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//
import Foundation

struct UserModel: Codable {
    let userId: Int
    let userName: String
    let userLastName: String
    let userDateOfBirth: String
    let userEmail: String
    let userPhone: String
    let userNote: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userLastName = "user_lastname"
        case userDateOfBirth = "user_date_of_birth"
        case userEmail = "user_email"
        case userPhone = "user_phone"
        case userNote = "user_note"
    }
}

extension UserModel {
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
}

extension UserModel: Equatable {
    
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        return ((lhs.userEmail == rhs.userEmail) && (lhs.userPhone == rhs.userPhone))
    }
}

extension UserModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userEmail)
    }
}

struct UserServerResponse: Codable {
    let message: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case message
        case userId = "user_id"
    }
}

typealias UsersResponse = [UserModel]
