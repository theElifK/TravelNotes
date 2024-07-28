//
//  SignUpVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 2.12.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet var passwords: [UITextField]!
    var userData: UserModel?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userData = UserModel.init(JSON: [:])
    }
    
    func checkFields(){
        self.view.endEditing(true)
        
        let name = self.nameTF.text ?? ""
        let surname = self.surnameTF.text ?? ""
        let email = self.emailTF.text ?? ""
        let password = self.passTF.text ?? ""
        
        
        if name == "" {
            
            self.errorMessage(titleInput: "Warning!" , messageInput: "Name field is required")
        }else if surname == ""{
            self.errorMessage(titleInput: "Warning!" , messageInput: "Surname field is required")
            
        }else if email == ""{
            self.errorMessage(titleInput: "Warning!" , messageInput: "Email field is required")
            
        }else if password == "" {
            self.errorMessage(titleInput: "Warning!" , messageInput: "Password field is required")
            
        }else if password.count < 6 {
            
            self.errorMessage(titleInput: "Warning!" , messageInput: "Your password cannot be less than 6 digits")
        }else{
            self.signUp(email: email, password: password, name: name, surname: surname)
        }
    }
    
    
 
}
//MARK: - Button Actions
extension SignUpVC{
    
    @IBAction func photoButtonClicked(_ sender: UIButton) {
        self.photoSelect()
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        self.checkFields()
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        guard let vc = AppDelegate.AuthStoryboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC else {
            return
        }
        
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }
    
    @IBAction func passVisibilityClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwords[sender.tag].isSecureTextEntry = !passwords[sender.tag].isSecureTextEntry
        sender.setImage(!sender.isSelected ? #imageLiteral(resourceName: "unhide_icon") : #imageLiteral(resourceName: "hide_icon"), for: .normal)
    }
    
    
}

//MARK: - UIImagePickerController, UINavigationControllerDelegate
extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func photoSelect(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
}

//MARK: - Firebase
extension SignUpVC{
    
    func signUp(email: String, password: String, name: String, surname: String ){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                self.errorMessage(titleInput: "Firebase Error", messageInput: error?.localizedDescription ?? "")
            }else{
                let _ : Bool = KeychainWrapper.standard.set(email, forKey: "email")
                
                let storage = Storage.storage()
                let storageReference = storage.reference()
                let mediaFolder = storageReference.child("media").child("userProfiles")
               
                if let data = self.profileImageView.image?.jpegData(compressionQuality: 0.5){
                    
                  
                    let uuid = UUID().uuidString
                    
                    let imageReference = mediaFolder.child("\(uuid).jpg")
                   
                    imageReference.putData(data) { (storagemetadata, error) in
                        if error != nil {
                            self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "You got an error, try again")
                            let _ : Bool = KeychainWrapper.standard.removeObject(forKey: "email")
                           
                        }else{
                            imageReference.downloadURL { (url, error) in
                                if error == nil {
                                    let imageUrlString = url?.absoluteString
                                    
                                    if let imageUrlString = imageUrlString{
                                        
        
                                        let db = Firestore.firestore()
                                      
                                        db.collection("Users").addDocument(data: ["profile_photo":imageUrlString, "first_name" : name, "last_name":surname,"email":email, "uid" : authResult?.user.uid]) {(err) in
                                            
                                            if err != nil{
                                                self.errorMessage(titleInput: "Warning!" , messageInput: "Error saving user data")
                                            }else{
                                                
                                                self.userData?.uid = authResult?.user.uid ?? ""
                                                self.getProfileInfo(userDataModel: self.userData!)
                                                self.initRoot()
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
 
}
