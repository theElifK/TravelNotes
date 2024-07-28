//
//  TripEditVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 9.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class TripEditVC: UIViewController {

    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var cityLabel: UILabel!
    var tripData : TravelNoteModel?
    var cityList = [CitiesModel]()
  
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        getCities()
        if let cities = CitiesModel.appCities{
            self.cityList = cities
        }
    }
  
}

//MARK: - Setups
extension TripEditVC{
    func setView(){
        self.tripImage.sd_setImage(with: URL(string: self.tripData?.photoUrl ?? ""))
        self.titleTF.text = self.tripData?.title ?? "-"
        self.descTV.text = self.tripData?.note ?? "-"
        self.cityLabel.text = self.tripData?.location?.name ?? "-"
    }
  
}
//MARK: - Functions
extension TripEditVC{
    
    func checkFields(){
        let photo = tripImage.image ?? nil
        let title = titleTF.text ?? ""
        let desc = descTV.text ?? ""
        let city = cityLabel.text ?? ""
       
        
        
        if photo == nil{
            self.errorMessage(titleInput: "Warning!" , messageInput: "Photo field is required")
            
        }else if title == ""{
            self.errorMessage(titleInput: "Warning!" , messageInput: "Title field is required")
            
        }else if desc == "" {
            self.errorMessage(titleInput: "Warning!" , messageInput: "Description field is required")
            
        }else{
            let locDictionary = ["name": city] as [String: Any]
            let noteDictionary = ["title": title, "note": desc, "location": locDictionary] as [String: Any]
            self.editData(noteData: self.tripData!, editData: noteDictionary)
        }
        
    }
}
//MARK: - Button Actions
extension TripEditVC{
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        self.checkFields()
       
    }
    
    @IBAction func cityButtonClicked(_ sender: UIButton) {
        let dropdown = showDropDownMenu(button: sender, width: sender.frame.width)
        dropdown.dataSource = self.cityList.map({$0.name ?? ""})
        dropdown.selectionAction = { (index: Int, item: String) in
            self.cityLabel.text = item
            
        }
        
        dropdown.show()
    }
}
//MARK: - Firebase
extension TripEditVC{
    
    func editData(noteData: TravelNoteModel ,editData:[String:Any]){
        let id = noteData.id
        let user = Auth.auth().currentUser
        let firestoreDB = Firestore.firestore()
        let collectionReference = firestoreDB.collection("MyNotes").whereField("id", isEqualTo: id).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil{
                    
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        firestoreDB.collection("MyNotes").document("\(document.documentID)").updateData(editData)
                    }
                }
                self.navigationController?.popViewController(animated: true)
            }})
    }
}
