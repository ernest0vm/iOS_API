//
//  AvailableResponse.swift
//  iOS_API
//
//  Created by Ernesto Valdez on 29/03/20.
//  Copyright © 2020 Ernesto Valdez. All rights reserved.
//

//   let availableResponse = try? JSONDecoder().decode(AvailableResponse.self, from: jsonData)

import Foundation
import SwiftyJSON

// MARK: - AvailableResponse
class AvailableResponse {
    var status: Int
    var error: Bool
    var data: [AvailableData]

    init(status: Int, error: Bool, data: [AvailableData]) {
        self.status = status
        self.error = error
        self.data = data
    }
    
    static func fromJSON (json: JSON) -> AvailableResponse{
        var objectArray: [AvailableData] = []
        let dataArray = json["data"].arrayValue
        dataArray.forEach { (JSON) in
            //print(JSON)
            let obj = AvailableData.fromJSON(json: JSON)
            objectArray.append(obj)
        }
        
        let availableResponse = AvailableResponse (
            status: json["status"].intValue,
            error: json["error"].boolValue,
            data: objectArray
        )
        return availableResponse
    }
}

// MARK: - AvailableData
class AvailableData : Identifiable {
    var tipo: String
    var peso, disponibles, usadas: Int
    var descripcion: String
    var activo: Bool
    var total: Int

    init(tipo: String, peso: Int, disponibles: Int, usadas: Int, descripcion: String, activo: Bool, total: Int) {
        self.tipo = tipo
        self.peso = peso
        self.disponibles = disponibles
        self.usadas = usadas
        self.descripcion = descripcion
        self.activo = activo
        self.total = total
    }
    
    static func fromJSON (json: JSON) -> AvailableData{
        let availableData = AvailableData (
            tipo: json["tipo"].stringValue,
            peso: json["peso"].intValue,
            disponibles: json["disponibles"].intValue,
            usadas: json["usadas"].intValue,
            descripcion: json["descripcion"].stringValue,
            activo: json["activo"].boolValue,
            total: json["total"].intValue
        )
        return availableData
    }
}
