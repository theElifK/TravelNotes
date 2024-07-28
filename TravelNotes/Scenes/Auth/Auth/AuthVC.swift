//
//  AuthVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 2.12.2023.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//MARK: - Button Actions
extension AuthVC{
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        guard let vc = AppDelegate.AuthStoryboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else {
              return
          }
        
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        guard let vc = AppDelegate.AuthStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else {
              return
          }
        
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
}
