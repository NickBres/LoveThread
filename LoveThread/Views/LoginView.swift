//
//  ContentView.swift
//  LoveThread
//
//  Created by Nikita Breslavsky on 02/10/2020.
//

import SwiftUI

var screenWidth = UIScreen.main.bounds.width

struct LoginView: View {
    
    @State var email: String = "test@test.com"
    @State var password: String = "123456"
    @State var isRemember = false
    @ObservedObject var viewModel: ViewModel
    
    
    var body: some View {
        NavigationView{
            ZStack {
                Rectangle()
                    .foregroundColor(Color("milk"))
                    .ignoresSafeArea()
                Image("thread")
                    .resizable()
                    .frame(width: screenWidth*1.7, height: 100)
                    .offset(x: viewModel.isReader ? 150 : -120,y: 120)
                    .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                Image("heart")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .offset(x: viewModel.isReader ? screenWidth :screenWidth/2)
                    .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                    .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.width > 0 {
                                        // right
                                        viewModel.isReader.toggle()
                                    }
                                    
                                }))
                Image("heart")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .offset(x: viewModel.isReader ? -screenWidth/2 : -screenWidth)
                    .animation(.spring(response: 1, dampingFraction: 1, blendDuration: 1))
                    .gesture(DragGesture(minimumDistance: 100, coordinateSpace: .local)
                                .onEnded({ value in
                                    if value.translation.width < 0 {
                                        // left
                                        viewModel.isReader.toggle()
                                    }
                                    
                                }))
                VStack {
                    Spacer()
                    Text("Sign in")
                        .font(.title)
                        .padding()
                    HStack{
                        Text("As")
                        Button(action: {
                            viewModel.isReader.toggle()
                        }){
                            Text(viewModel.isReader ? "Reader" : "Writer")
                                .foregroundColor(Color("blood"))
                                .frame(width: 60, height: 10)
                        }.padding()
                        .shadow(radius: 4, x: 0, y: 3)
                        
                        
                        
                    }
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
                    Button(action: {
                        viewModel.login(email: email, password: password)
                    }){
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 20)
                    }.padding()
                    .background(Color("blood"))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow( radius: 4, x: 0, y: 3)
                    
                    Text("or")
                        .font(.footnote)
                        .padding()
                        .foregroundColor(.gray)
                    HStack {
                        Text("Dont have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            viewModel.showSheetRegister.toggle()
                        }){
                            Text("Sign up")
                            
                        }
                    }
                    
                }
            }
            .sheet(isPresented: $viewModel.showSheetRegister){
                RegisterSheet(viewModel: viewModel)
            }
            .alert(isPresented: $viewModel.isLoginAlertError){
                Alert(title: Text("Error"), message: Text(viewModel.errorLogin ?? ""), dismissButton: .cancel())
            }
            .navigationTitle(Text("Love Thread"))
            
            
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: ViewModel())
    }
}
