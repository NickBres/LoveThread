//
//  MainView.swift
//  LoveThread
//
//  Created by Nikita Breslavsky on 03/10/2020.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        VStack{
        if viewModel.isEntered{
            if viewModel.isReader{
                RecipientView()
            }else{
                SenderView(viewModel: viewModel)
            }
        }else{
            LoginView(viewModel: viewModel)
        }
        }.animation(.spring())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
