//
//  AddTripVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 31.12.2023.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore


class AddTripVC: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var startDateTF: UITextField!
    @IBOutlet weak var endDateTF: UITextField!
    @IBOutlet weak var locButton: UIButton!
    
    var datePicker  = UIDatePicker()
    var cityList = [CitiesModel]()
   
    
    var lat : String = ""
    var lng : String = ""
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        addPickerStart()
        addPickerEnd()
        getCities()
        if let cities = CitiesModel.appCities{
            self.cityList = cities
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Add Note"
        self.clearView()
       
    }
 
}
//MARK: - Functions
extension AddTripVC{
    
      func clearView(){
          self.view.endEditing(true)
          self.photoView.image = #imageLiteral(resourceName: "photo_bg")
          self.titleTF.text = ""
          self.noteTV.text = ""
          self.cityTF.text = ""
          self.startDateTF.text = ""
          self.endDateTF.text = ""
      }
      
      func checkFields(){
          let photo = photoView.image ?? nil
          let title = titleTF.text ?? ""
          let desc = noteTV.text ?? ""
          let city = cityTF.text ?? ""
          let startDate = startDateTF.text ?? ""
          let endDate = endDateTF.text ?? ""
          
          
          if photo == nil{
              self.errorMessage(titleInput: "Warning!" , messageInput: "Photo field is required")
              
          }else if title == ""{
              self.errorMessage(titleInput: "Warning!" , messageInput: "Title field is required")
              
          }else if desc == "" {
              self.errorMessage(titleInput: "Warning!" , messageInput: "Description field is required")
              
          }else{
             
              self.addTrip(title:title, desc:desc, city: city)
          }
      }
}
//MARK: - Button Actions
extension AddTripVC{
    @IBAction func locationButtonClicked(_ sender: UIButton) {
     
    }
    
    @IBAction func addPhotoClicked(_ sender: UIButton) {
        
        self.photoSelect()
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        self.checkFields()
        
    }
    
    @IBAction func cityButtonClicked(_ sender: UIButton) {
        
        let dropdown = showDropDownMenu(button: sender, width: sender.frame.width)
        dropdown.dataSource = self.cityList.map({$0.name ?? ""})
        dropdown.selectionAction = { (index: Int, item: String) in
            self.cityTF.text = item
            
        }
        
        dropdown.show()
    }
}

//MARK: - UIImagePickerController, UINavigationControllerDelegate
extension AddTripVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func photoSelect(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photoView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
}

//MARK: - Date and Time Picker
extension AddTripVC{
    func addPickerStart(){
        self.startDateTF.datePicker(target: self,
                                    doneAction: #selector(doneAction),
                                    cancelAction: #selector(cancelAction),
                                    datePickerMode: .date)
        
    }
    func addPickerEnd(){
        
        self.endDateTF.datePicker(target: self,
                                  doneAction: #selector(doneAction1),
                                  cancelAction: #selector(cancelAction),
                                  datePickerMode: .date)
    }
    @objc func cancelAction() {
        self.startDateTF.resignFirstResponder()
        self.endDateTF.resignFirstResponder()
    }
    
    @objc func doneAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let datePickerView = self.startDateTF.inputView as? UIDatePicker {
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.startDateTF.text = dateString
            
            
            self.startDateTF.resignFirstResponder()
        }
    }
    
    @objc func doneAction1() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let datePickerView = self.endDateTF.inputView as? UIDatePicker {
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.endDateTF.text = dateString
            
            
            self.endDateTF.resignFirstResponder()
        }
    }
}

//MARK: - Firebase
extension AddTripVC{
    func addTrip(title:String, desc:String, city: String){
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media").child("photos")
        // converts the photo we select into data.
        if let data = photoView.image?.jpegData(compressionQuality: 0.5){
            
            // to have a different name each time
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            //Metadata is used to send information about where and when the photo was taken.
            imageReference.putData(data) { (storagemetadata, error) in
                if error != nil {
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "You got an error, try again")
                    
                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrlString = url?.absoluteString
                            
                            if let imageUrlString = imageUrlString{
                                
                                let firestoreDB = Firestore.firestore()
                                let userDictionary = ["user_id": UserModel.currentUser?.uid ?? "", "first_name": UserModel.currentUser?.first_name, "last_name":UserModel.currentUser?.last_name, "profile_photo":UserModel.currentUser?.profile_photo, "email":UserModel.currentUser?.email] as [String: Any]
                                let locDictionary = ["name": city]
                                
                                let noteDictionary = ["id": uuid,"photoUrl": imageUrlString, "title": title, "note": desc,"user": userDictionary,"location": locDictionary, "date": FieldValue.serverTimestamp()] as [String: Any]
                             
                                firestoreDB.collection("MyNotes").addDocument(data: noteDictionary){
                                    (error) in
                                    
                                    if error != nil {
                                        
                                        self.errorMessage(titleInput: "Warning!" , messageInput: "You got an error, try again")
                                        
                                    }else {
                                        self.clearView()
                                        self.tabBarController?.selectedIndex = 1
                                        
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

