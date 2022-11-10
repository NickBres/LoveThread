//
//  SenderView.swift
//  LoveThread
//
//  Created by Nikita Breslavsky on 02/10/2020.
//

import SwiftUI

struct Quote: Identifiable{
    var id = UUID()
    var text:String
}

struct WriterView: View {
    
    @ObservedObject var viewModel: ViewModel
    @State var quotes: [Quote] = []
    @State var newText = ""
    @State var isMyMenu = false
    @State var showConnect  = false
    
    
    var body: some View {
        NavigationView {
            ZStack{
                Rectangle()
                    .foregroundColor(Color("milk"))
                    .ignoresSafeArea()
            VStack {
                if isMyMenu{
                    SenderMenu(viewModel: viewModel)
                }
                
                
                List{
                    HStack {
                        TextField("New quote", text: $newText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            if newText != ""{
                                quotes.append(Quote(text: newText))
                                newText = ""
                                
                            }
                        }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .frame(width: 35)
                                .foregroundColor(Color("blood"))
                                .shadow(radius: 4, x: 0, y: 3)
                        })
                    }.listRowBackground(Color("milk"))
                    ForEach (quotes){ quote in
                        Text(quote.text)
                            .listRowBackground(Color("milk"))
                    }.onDelete(perform: { indexSet in
                        quotes.remove(at: indexSet.first!)
                    })
                }.background(Color("milk"))
                .listStyle(InsetListStyle())
                
                
            }
            .navigationBarTitle("Writer",displayMode: .inline)
            
            .navigationBarItems(leading: Button(action: {
                isMyMenu.toggle()
            }, label: {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }))
        }.animation(.spring())
        
        
    }
    }
}

struct SenderView_Previews: PreviewProvider {
    static var previews: some View {
        WriterView(viewModel: ViewModel())
    }
}

struct SenderMenu:View{
    @ObservedObject var viewModel: ViewModel
    @State var showRequestStatus = false
    
    var body: some View {
        HStack(spacing: screenWidth/20){
            Button(action: {
                viewModel.checkThreads(collection: C.writerThreads, email: viewModel.userData.email ?? "")
                showRequestStatus.toggle()
            }) {
                VStack {
                    Image(systemName: viewModel.currentThread?.status ?? "" == C.statusAccepted  ? "heart.circle" : "heart.slash.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .shadow(radius: 4, x: 0, y: 3)
                    Text(viewModel.currentThread?.userName ?? "" == "" ?  "Not connected" : "\(viewModel.currentThread?.userName ?? "Connected")")
                }
            }
            Button(action: {
                viewModel.signOut()
            }) {
                VStack {
                    Image(systemName:"person.crop.circle.badge.xmark" )
                        .resizable()
                        .frame(width: 60, height: 50)
                        .shadow(radius: 4, x: 0, y: 3)
                    Text("Sign out")
                }
            }
        }
        .padding()
        if showRequestStatus{
            ConnectView(viewModel: viewModel, showConnect: $showRequestStatus)
            
        }
    }
}


struct ConnectView:View{
    
    @ObservedObject var viewModel: ViewModel
    @State var emailToConnect = ""
    @Binding var showConnect: Bool
    
    var body: some View {
        if let thread = viewModel.currentThread{
            switch thread.status{
            case C.statusWaiting:
                HStack{
                    HStack{
                        Text("Waiting for ")
                        Text("\(thread.userEmail ?? "")")
                            .foregroundColor(Color("blood"))
                        Text(" to confirm")
                        
                    } .padding()
                    Spacer()
                    Button(action: {
                        viewModel.deleteThread(collection: C.recipientThreads, email: thread.userEmail ?? "")
                        viewModel.deleteThread(collection: C.writerThreads, email: viewModel.userData.email ?? "")
                        showConnect.toggle()
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .shadow(radius: 4, x: 0, y: 3)
                    }).padding()
                }
            case C.statusAccepted:
                HStack{
                    Spacer()
                    VStack{
                        Text("Connected to")
                        Text("\(thread.userEmail ?? "email error")")
                    }
                    Spacer()
                    Button(action: {
                        viewModel.deleteThread(collection: C.writerThreads, email: viewModel.userData.email ?? "")
                        viewModel.declineThread(collection: C.recipientThreads, email: thread.userEmail ?? "")
                        
                        showConnect.toggle()
                    }){
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .shadow( radius: 4, x: 0, y: 3)
                    }
                    Spacer()
                    
                    
                }
            default:
                HStack{
                    Spacer()
    
                        Text("Thread declined")
                        
                    Spacer()
                    Button(action: {
                        viewModel.deleteThread(collection: C.writerThreads, email: viewModel.userData.email ?? "")
                        showConnect.toggle()
                    }){
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .shadow( radius: 4, x: 0, y: 3)
                    }
                    Spacer()
                    
                    
                }
                
            }
        }else{
            HStack{
                TextField("Enter second person email", text: $emailToConnect)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
                Button(action: {
                    if emailToConnect != ""{
                        viewModel.createThreads(requestedEmail: emailToConnect)
                        emailToConnect = ""
                        showConnect.toggle()
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .shadow(radius: 4, x: 0, y: 3)
                    
                    
                }).padding()
            }
        }
    }
}
