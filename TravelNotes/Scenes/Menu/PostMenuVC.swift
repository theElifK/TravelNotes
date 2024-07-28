//
//  PostMenuVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 29.06.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
protocol PostMenuDelegate{
    func openEditPage(data: TravelNoteModel)
}
class PostMenuVC: UIViewController {
    
    var delegate: PostMenuDelegate?
    var tripData : TravelNoteModel?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
 
}
//MARK: - Button Actions
extension PostMenuVC{
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        self.deleteNote(noteData: self.tripData!)
        
    }
    @IBAction func editButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.openEditPage(data: self.tripData!)
        })
      
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
}

//MARK: - Firebase
extension PostMenuVC{
    
    func deleteNote(noteData: TravelNoteModel) {
        
        
        // 1. First Delete the childs image from storage
        let storage = Storage.storage()
        let imageURL = noteData.photoUrl ?? ""
        let storageReference = storage.reference(forURL: imageURL)
        storageReference.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("File deleted successfully")
            }
        }
       
        // 2. Now Delete the Child from the database
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
                        firestoreDB.collection("MyNotes").document("\(document.documentID)").delete()
                    }
                }
                self.dismiss(animated: true)
            }})

       
        
    }
}
