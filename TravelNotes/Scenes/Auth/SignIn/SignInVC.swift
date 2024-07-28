//
//  SignInVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 2.12.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    var userData: UserModel?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userData = UserModel.init(JSON: [:])
        if KeychainWrapper.standard.string(forKey: "email") != nil{
            let retrievedString: String? = KeychainWrapper.standard.string(forKey: "email")
            self.emailTF.text = retrievedString
        }
    }
    func checkFields(){
        self.view.endEditing(true)
       
        let email = self.emailTF.text ?? ""
        let password = self.passTF.text ?? ""

        
        if email == ""{
            self.errorMessage(titleInput: "Warning!" , messageInput: "Email field is required")
           
        }else if password == "" {
            self.errorMessage(titleInput: "Warning!" , messageInput: "Password field is required")
           
        }else if password.count < 6 {
            
            self.errorMessage(titleInput: "Warning!" , messageInput: "Your password cannot be less than 6 digits")
        }else{
          
            self.signIn(email: email, password: password)
        }
    }
    
}

//MARK: - Button Actions
extension SignInVC{
    

    @IBAction func signInButtonClicked(_ sender: UIButton) {
        self.checkFields()
    }
    
    @IBAction func passVisibilityClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passTF.isSecureTextEntry = !passTF.isSecureTextEntry
        sender.setImage(!sender.isSelected ? #imageLiteral(resourceName: "unhide_icon") : #imageLiteral(resourceName: "hide_icon"), for: .normal)
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        
        guard let vc = AppDelegate.AuthStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else {
              return
          }
        
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
}

//MARK: - Firebase
extension SignInVC{
    
    func signIn(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                let _ : Bool = KeychainWrapper.standard.removeObject(forKey: "email")
                
                self.errorMessage(titleInput: "Firebase Error", messageInput: error?.localizedDescription ?? "")
            }else{
                let _ : Bool = KeychainWrapper.standard.set(email, forKey: "email")
                
                self.userData?.uid = authResult?.user.uid ?? ""
                self.getProfileInfo(userDataModel: self.userData!)
                self.initRoot()
                
                
            }
        }
        
    }
}
