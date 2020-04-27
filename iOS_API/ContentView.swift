//
//  ContentView.swift
//  iOS_API
//
//  Created by Ernesto Valdez on 27/03/20.
//  Copyright © 2020 Ernesto Valdez. All rights reserved.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text?
    var dismissButton: Alert.Button?
}

struct LoginView: View {
    @State private var email: String = "pruebas@globalpaq.com"
    @State private var password: String = "pruebas"
    @State private var isLogged: Bool = false
    @State private var alertItem: AlertItem?
    
    private func errorAlert(title: String, message: String) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("Aceptar")))
    }
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    TextField("Ingresa correo", text: $email)
                        .textContentType(UITextContentType.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Ingresa contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.bottom, 50)
                
                NavigationLink(destination: MainView(), isActive: $isLogged) {
                    Text("Show Detail View")
                }.hidden()
                
                Button(action: {
                    
                    if (self.email.isEmpty){
                        self.alertItem = AlertItem(title: Text("Falta correo"), message: Text("El correo no puede estar vacio"))
                        return
                    }
                    
                    if (self.password.isEmpty){
                        self.alertItem = AlertItem(title: Text("Falta contraseña"), message: Text("La contraseña no puede estar vacia"))
                        return
                    }
                    
                    debugPrint("correo: " + self.email.lowercased())
                    debugPrint("password: " + self.password.lowercased())
                    
                    ApiManager.shared.login(
                            email: self.email.lowercased(),
                            password: self.password.lowercased(),
                            completion: {loginResult, message in
                                self.isLogged = loginResult
                                
                                if !self.isLogged{
                                    self.alertItem = AlertItem(title: Text("No se puede iniciar sesion"), message: Text(message))
                                }
                    })
                
                    }) {
                    Text("Iniciar Sesion")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.body)
                        .cornerRadius(15)
                }.alert(item: $alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
            }.navigationBarTitle("Inicio")
            .padding(.horizontal, 20.0)
        }
    }
}

struct MainView: View {
    
    @State private var availableItems = [AvailableData]()
    
    var body: some View {
        List {
            ForEach(availableItems) { item in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Descripcion: \(item.descripcion)")
                        Spacer()
                        if item.activo {
                            Image(systemName: "checkmark.circle").foregroundColor(.green)
                        } else {
                            Image(systemName: "circle").foregroundColor(.gray)
                        }
                    }
                    Text("tipo: \(item.tipo)")
                    Text("peso: \(item.peso)")
                    Text("total: \(item.total)")
                    Text("disponibles: \(item.disponibles)")
                    Text("usadas: \(item.usadas)")
                }
            }
        }.onAppear {
            ApiManager.shared.getAvailable { itemList in
                self.availableItems = itemList
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
