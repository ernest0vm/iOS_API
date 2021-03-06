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
    private var token = ""
    let BASE_URL: String = "https://sistema.globalpaq.mx/api/v2/public"
    
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        
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
                    
                    if authResponse.data.message.isEmpty{
                        self.token = authResponse.data.token
                        debugPrint("token: \(self.token)")
                        completion(true, "token is ready")
                    } else {
                        debugPrint("message: \(authResponse.data.message)")
                        completion(false, authResponse.data.message)
                    }

                case .failure(let error):
                    debugPrint(error)
                    completion(false, "failure in response")
                }
            }
}
    
    func getAvailable(completion: @escaping ([AvailableData]) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": self.token
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
                    debugPrint("data available: \(getAvailable.data.count)")
                    completion(getAvailable.data)
                    
                case .failure(let error):
                    print (error)
                    completion([AvailableData]())
                }
        }
    }
    
}
