//
//  AuthResponse.swift
//  iOS_API
//
//  Created by Ernesto Valdez on 29/03/20.
//  Copyright © 2020 Ernesto Valdez. All rights reserved.
//

//   let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: jsonData)

import Foundation
import SwiftyJSON

// MARK: - AuthResponse
class AuthResponse {
    var data: AuthData
    var err: Bool
    var status: Int

    init(data: AuthData, err: Bool, status: Int) {
        self.data = data
        self.err = err
        self.status = status
    }
    
    static func fromJSON (json: JSON) -> AuthResponse{
        let authResponse = AuthResponse (
            data: AuthData.fromJSON(json: json["data"]),
            err: json["err"].boolValue,
            status: json["status"].intValue
        )
        return authResponse
    }
}

// MARK: - AuthData
class AuthData {
    var token, message: String

    init(token: String, message: String) {
        self.token = token
        self.message = message
    }
    
    static func fromJSON (json: JSON) -> AuthData{
        let authData = AuthData(
        token: json["token"].stringValue,
        message: json["message"].stringValue
        )
        return authData
    }
}
