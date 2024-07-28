//
//  ProfileVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 26.12.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    let cellID = "ProfileCollectionCell"
    private var total = 0
    var myTripsArray = [TravelNoteModel]()
    var myTripData : TravelNoteModel?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Profile"
        self.setView()
        self.getMyTrips()
    }

}

//MARK: - Setups
extension ProfileVC{
    func setView(){
        self.profileImage.sd_setImage(with: URL(string: UserModel.currentUser?.profile_photo ?? ""))
        self.emailLabel.text = UserModel.currentUser?.email ?? "-"
        self.fullNameLabel.text = (UserModel.currentUser?.first_name ?? "-") + " " + (UserModel.currentUser?.last_name ?? "-")
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
      
       
    }
}
//MARK: - Button Actions
extension ProfileVC{
    
    @IBAction func singOutButtonClicked(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            UserModel.currentUser = nil
            self.initRoot()
        }catch{
            print("Error SignOut")
        }
        
    }
    
    
    
}
//MARK: - UICollectionViewDataSource
extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ProfileCollectionCell else {
            return UICollectionViewCell()
        }
     
        cell.configCell(travelData: myTripsArray[indexPath.row])
      
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
       self.presentToMenu(data: self.myTripsArray[indexPath.row])
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 110 , height: 110)
    }
}
//MARK: - Router
extension ProfileVC{
    
    func presentToMenu(data: TravelNoteModel?){
        guard let vc = AppDelegate.MainStoryboard.instantiateViewController(withIdentifier: "PostMenuVC") as? PostMenuVC else {
              return
          }
        vc.tripData = data
        vc.delegate = self
        openFithedSheets(vc: vc, height: 200)
    
    }
    
    func navigateToTripDetail(data: TravelNoteModel?){
        guard let vc = AppDelegate.MainStoryboard.instantiateViewController(withIdentifier: "TripEditVC") as? TripEditVC else {
            return
        }
        vc.tripData = data
        vc.modalPresentationStyle = .currentContext
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - PostMenuDelegate
extension ProfileVC: PostMenuDelegate{
    func openEditPage(data: TravelNoteModel) {
        self.navigateToTripDetail(data: data)
    }
    
    
    
}
//MARK: - Firebase
extension ProfileVC{
    
    func getMyTrips(){
      
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("MyNotes").whereField("user.user_id", isEqualTo: UserModel.currentUser?.uid).getDocuments(){ snapshot, error in
            if error != nil {
                self.errorMessage(titleInput: "Warning!", messageInput: error?.localizedDescription ?? "Try again")
            }else{
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil{
                    self.myTripsArray.removeAll()
                    for document in snapshot!.documents {
                      
                        self.myTripData = TravelNoteModel.init(JSON: [:])
                        if let id = document.get("id") as? String {
                            self.myTripData?.id = id
                        }
                        if let url = document.get("photoUrl") as? String {
                            self.myTripData?.photoUrl = url
                        }
                        
                        if let title = document.get("title") as? String {
                            self.myTripData?.title = title
                            
                        }
                        if let user = document.get("user") as? [String: Any] {
                            let userData = UserModel(JSON: user)
                            self.myTripData?.user = userData
                            
                        }
                        if let loc = document.get("location") as? [String: Any] {
                            let locData = CitiesModel(JSON: loc)
                            self.myTripData?.location = locData
                            
                        }
                        if let note = document.get("note") as? String {
                            self.myTripData?.note = note
                        }
                        if let date = document.get("date") as? Timestamp {
                            let date = date.dateValue()
                            self.myTripData?.date = date.toStringDate()
                        }
                        
                        self.myTripsArray.append(self.myTripData!)
            
                    }
                    self.myTripsArray = self.myTripsArray.sorted(by: {($0.date ?? "") > ($1.date ?? "")})
                    self.total = self.myTripsArray.count ?? 0
                    if self.myTripsArray.count > 0 {
                        self.collectionView.reloadData()
                        self.collectionView.isHidden = false
                        self.noDataView.isHidden = true
                    }else{
                        self.collectionView.isHidden = true
                        self.noDataView.isHidden = false
                    }
                }else{
                    self.collectionView.isHidden = true
                    self.noDataView.isHidden = false
                }
             
                
            }
        }
    }
    
}
