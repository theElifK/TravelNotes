//
//  UIViewControllerExtension.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 5.12.2023.
//

import UIKit
import Foundation
import DropDown
import FirebaseAuth
import FittedSheets
import FirebaseFirestore

extension UIViewController {
    
    
    func initRoot(withRootIdentifier Identifier: String = "MainNavigation", storyboard: UIStoryboard = AppDelegate.MainStoryboard){
       
        var mainwindow: UIWindow?
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            let sd : SceneDelegate = ((scene?.delegate as? SceneDelegate)!)
            mainwindow = sd.window
        }
        var vc: UIViewController?
        
        let isLoggedIn =  Auth.auth().currentUser
        if isLoggedIn != nil {
            vc = AppDelegate.MainStoryboard.instantiateViewController(withIdentifier: "MainNavigation") as? UINavigationController
            if let window = mainwindow {
                window.rootViewController = vc
                UIView.transition(with: window, duration: 1, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
            
        }else{
            vc = AppDelegate.AuthStoryboard.instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
            if let window = mainwindow {
                window.rootViewController = vc
                UIView.transition(with: window, duration: 1, options: .transitionCrossDissolve, animations: nil, completion: nil)
                
            }
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func showDropDownMenu(button : UIButton, width: CGFloat) -> DropDown{
        let dropDown = DropDown()
        dropDown.anchorView = button
        dropDown.width = width > button.frame.width ? width : button.frame.width
        dropDown.backgroundColor = .white
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.cornerRadius = 6
        return dropDown
    }
    func SheetOptionView() -> SheetOptions{
        let options = SheetOptions(
            pullBarHeight: 24,
            presentingViewCornerRadius: 20,
            shouldExtendBackground: true,
            setIntrinsicHeightOnNavigationControllers: true,
            useFullScreenMode: false,
            shrinkPresentingViewController: false,
            useInlineMode : false, horizontalPadding: 0,
            maxWidth: nil
        )
        return options
        
        
        
    }
    func openFithedSheets(vc: UIViewController, height: Double){
        
        let sheetController = SheetViewController(
            controller: vc,
            sizes: [.fixed(height)],
            options:vc.SheetOptionView())
        sheetController.cornerRadius = 24
        sheetController.gripSize = CGSize(width: 0, height: 0)
        sheetController.gripColor = .placeholderText
        sheetController.minimumSpaceAbovePullBar = 0
        sheetController.pullBarBackgroundColor = .white
        sheetController.treatPullBarAsClear = false
        sheetController.dismissOnOverlayTap = true
        sheetController.dismissOnPull = true
        sheetController.allowPullingPastMaxHeight = false
        sheetController.autoAdjustToKeyboard = true
        sheetController.overlayColor = UIColor.gray.withAlphaComponent(0.6)
        sheetController.modalPresentationStyle = .overFullScreen
        self.present(sheetController, animated: true, completion: nil)
        
    }
    func getCities(){
     
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("Cities").order(by: "id", descending: false).addSnapshotListener { snapshot, error in
            if error != nil {
                self.errorMessage(titleInput: "Warning!", messageInput: error?.localizedDescription ?? "Try again")
            }else{
               
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil{
                   var cityList = [CitiesModel]()
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        var cityData = CitiesModel.init(JSON: [:])
                        
                        if let plate_number = document.get("id") as? Int {
                           cityData?.id = plate_number
                        }
                        
                        if let name = document.get("name") as? String {
                            cityData?.name = name
                            
                        }
                        if let latitude = document.get("latitude") as? String {
                           cityData?.latitude = latitude
                        }
                        
                        if let longitude = document.get("longitude") as? String {
                            cityData?.longitude = longitude
                            
                        }
                        if let population = document.get("population") as? Int {
                           cityData?.population = population
                        }
                        
                        if let region = document.get("region") as? String {
                            cityData?.region = region
                            
                        }
                        
                        cityList.append(cityData!)
                       
                       
                    }
                    CitiesModel.appCities = cityList
                }
               
            }
           
        }
      
    }
    
    func getProfileInfo(userDataModel: UserModel){
     
       var userData = UserModel.init(JSON: [:])
        userData = userDataModel
     
        let firestoreDB = Firestore.firestore()
    
        firestoreDB.collection("Users").whereField("uid", isEqualTo:  userData?.uid).getDocuments(){snapshot, error in
            if error != nil {
                self.errorMessage(titleInput: "Warning!", messageInput: error?.localizedDescription ?? "Try again")
            }else{
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil{
                    for document in snapshot!.documents {
                       
                        
                        if let uuid = document.get("uid") as? String {
                           userData?.uid = uuid
                           
                        }
                        
                        if let profile_photo_url = document.get("profile_photo") as? String {
                            userData?.profile_photo = profile_photo_url
                        }
                        
                        if let email = document.get("email") as? String {
                            userData?.email = email
                        }
                        
                        if let first_name = document.get("first_name") as? String {
                            userData?.first_name = first_name
                            
                        }
                        
                        if let last_name = document.get("last_name") as? String {
                            userData?.last_name = last_name
                        }
                        UserModel.currentUser = userData
                    }
                 
                }
                
            }
        }
    }
}

extension Date{
    
    func toStringDate(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
}
