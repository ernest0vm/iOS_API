//
//  ApiManager.swift
//  iOS_API
//
//  Created by Ernesto Valdez on 30/03/20.
//  Copyright © 2020 Ernesto Valdez. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiManager {
    static var shared = ApiManager()
    
    var BASE_URL: String {
        get {return "https://sistema.globalpaq.net/api/v2/public"}
    }
    
    func login(email: String, password: String) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters: [String: String] = [
            "correo" : email,
            "password" : password
        ]
        Alamofire.request(BASE_URL + "/asociado/login",
                          method: .post,
                          parameters: parameters,
                          headers: headers
        ).responseJSON { response in
            //print(response!)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //debugPrint(json)
                
                let authResponse = AuthResponse.fromJSON(json: json)
                
                let token = authResponse.data.token
                Globals.shared.TOKEN = token
                //debugPrint("token: \(Globals.shared.TOKEN)")
                
                self.getAvailable(token: token)

            case .failure(let error):
                print (error)
            }
        }
    }
    
    func getAvailable(token: String) {
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        Alamofire.request(BASE_URL + "/dhl/disponibles",
                          method: .get,
                          headers: headers
        ).responseJSON { response in
                //print(response!)
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //debugPrint(json)
                    
                    let getAvailable = AvailableResponse.fromJSON(json: json)
                    //debugPrint("data available: \(getAvailable.data[0].descripcion)")
                    
                case .failure(let error):
                    print (error)
                }
        }
    }
    
}
