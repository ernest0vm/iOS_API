//
//  ContentView.swift
//  iOS_API
//
//  Created by Ernesto Valdez on 27/03/20.
//  Copyright © 2020 Ernesto Valdez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var email: String = "pruebas@globalpaq.com"
    @State private var password: String = "pruebas"
    @State private var isLogged: Bool = false
    
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
                NavigationLink(destination: DetailView(), isActive: $isLogged) {
                    Text("Show Detail View")
                }.hidden()
                Button(action: {
                    
                    if (self.email.isEmpty){
                        return
                    }
                    
                    if (self.password.isEmpty){
                        return
                    }
                    
                    print("correo: " + self.email.lowercased())
                    print("password: " + self.password.lowercased())
                    
                    ApiManager.shared.login(
                        email: self.email.lowercased(),
                        password: self.password.lowercased())
                    
                    }) {
                    Text("Iniciar Sesion")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.body)
                        .cornerRadius(15)
                }
                .navigationBarTitle("Inicio de Sesion")
            }
            .padding(.horizontal, 20.0)
        }
        
    }
}

struct DetailView: View {
    var body: some View {
        Text("This is the detail view")
    }
}

struct Toast<Presenting>: View where Presenting: View {
    
    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack(alignment: .center) {
                
                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)
                
                VStack {
                    self.text
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                    .background(Color.secondary.colorInvert())
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .transition(.slide)
                    .opacity(self.isShowing ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.isShowing = false
                            }
                        }
                }
            }
        }
    }
}

extension View {
    
    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
