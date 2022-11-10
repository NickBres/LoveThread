//
//  RegisterSheet.swift
//  Love Thread
//
//  Created by Nikita Breslavsky on 01/10/2020.
//

import SwiftUI

struct RegisterSheet: View {
    
    @State var name: String = "Tester Testerovich"
    @State var email: String = "test@test.com"
    @State var password: String = "123456"
    @State var confirmPassword: String = "123456"
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color("milk"))
                .ignoresSafeArea()
            VStack{
                Text("Sign up")
                    .font(.title)
                    .padding()
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(Color("blood"))
                        .padding(.all, 7)
                    TextField("Name", text: $name)
                }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("blood"),lineWidth: 1))
                .padding(.horizontal)
                .frame(width: screenWidth)
                HStack {
                    Image(systemName: "envelope.circle")
                        .foregroundColor(Color("blood"))
                        .padding(.all, 7)
                    TextField("Email", text: $email)
                       
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("blood"),lineWidth: 1))
                .padding(.horizontal)
                .frame(width: screenWidth)
                HStack {
                    Image(systemName: "lock.circle")
                        .foregroundColor(Color("blood"))
                        .padding(.all, 7)
                    SecureField("Password", text: $password)
                }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("blood"),lineWidth: 1))
                .padding(.horizontal)
                .frame(width: screenWidth)
                HStack {
                    Image(systemName: "lock.circle")
                        .foregroundColor(Color("blood"))
                        .padding(.all, 7)
                    SecureField("Confirm Password", text: $confirmPassword)
                }.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("blood"),lineWidth: 1))
                .padding(.horizontal)
                .frame(width: screenWidth)
                Button(action: {
                    viewModel.createUser(name: name, email: email, password: password, confirm: confirmPassword)
                }){
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 20)
                }.padding()
                .background(Color("blood"))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 4, x: 0, y: 3)
            }
        }.alert(isPresented: $viewModel.isRegisterAlertError, content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorRegister ?? ""), dismissButton: .cancel())
        })
    }
}

struct RegisterSheet_Previews: PreviewProvider {
    static var previews: some View {
        RegisterSheet(viewModel: ViewModel())
    }
}
