//
//  ViewModel.swift
//  LoveThread
//
//  Created by Nikita Breslavsky on 02/10/2020.
//

import Foundation
import Firebase
import FirebaseAuth


class ViewModel: ObservableObject{
    
    @Published var userData: UserData?
    
    @Published var isLoginAlertError = false
    @Published var errorLogin: String?
    
    @Published var isRegisterAlertError = false
    @Published var showSheetRegister: Bool = false
    @Published var errorRegister: String?
    
    @Published var isEntered = UserDefaults.standard.bool(forKey: "isEntered")
    @Published var isReader = false
    
    func logOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        if firebaseAuth.currentUser == nil {
            UserDefaults.standard.set(false,forKey: "isEntered")
            self.isEntered = UserDefaults.standard.bool(forKey: "isEntered")
        }
    }
    
    func login(email:String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let e = error{
                print(e.localizedDescription)
                self!.errorLogin = e.localizedDescription
                self!.isLoginAlertError.toggle()
            }else{
                if let user = Auth.auth().currentUser{
                    self!.userData = UserData(email: user.email ?? "no email", name: user.displayName ?? "no name", uid: user.uid, connectedId: nil)
                    UserDefaults.standard.set(true,forKey: "isEntered")
                    self?.isEntered = UserDefaults.standard.bool(forKey: "isEntered")
                }
            }
            // ...
        }
    }
    
    func createUser(name: String, email: String, password: String, confirm: String){
        var errorResult: String?
        if checkPassword(password: password, confirm: confirm){
            Auth.auth().createUser(withEmail: email, password: password){ [self] authResult, error in
                if let e = error{
                    print(e.localizedDescription)
                    errorRegister =  e.localizedDescription
                    isRegisterAlertError.toggle()
                }else{
                    print(name)
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { (error) in
                        if let e = error{
                            print(e.localizedDescription)
                            errorRegister =  e.localizedDescription
                            isRegisterAlertError.toggle()
                        }else{
                            if let user = Auth.auth().currentUser{
                                self.userData = UserData(email: user.email ?? "no email", name: user.displayName ?? "no name", uid: user.uid, connectedId: nil)
                                showSheetRegister.toggle()
                                print(self.userData!)
                            }
                        }
                    }
                    
                }
            }
            
        }else{
            errorRegister = "Passwords not same"
            isRegisterAlertError.toggle()
        }
        
    }
    func checkPassword(password: String, confirm: String) -> Bool{
        return password == confirm
    }
    
}

struct UserData{
    
    var email: String
    var name: String
    var uid: String
    var connectedId: String?
    
}
