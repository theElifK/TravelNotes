//
//  MyTripsVC.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 31.12.2023.
//

import UIKit
import FirebaseFirestore

class MyTripsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    var cellID = "TripCell"
    private var total = 0
    var tripsArray = [TravelNoteModel]()
    var tripData : TravelNoteModel?
    let refreshControl = UIRefreshControl()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getCities()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "My Trips"
        self.getTrips()
       
    }
}
//MARK: - Setups
extension MyTripsVC{
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.reloadData()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh",attributes: attributes)
        refreshControl.tintColor = .lightGray
        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    @objc func pullRefresh(){
        self.tripsArray = []
        self.total = 0
        self.getTrips()
    }
    

    
}
//MARK: - UITableViewDataSource
extension MyTripsVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:cellID) as? TripCell else {
                return UITableViewCell()
        }
        cell.configCell(data: tripsArray[indexPath.row])
        return cell
       
    }
  
    
}

//MARK: - UITableViewDelegate
extension MyTripsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}

//MARK: - Firebase
extension MyTripsVC{
    
    func getTrips(){
        refreshControl.endRefreshing()
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("MyNotes").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.errorMessage(titleInput: "Warning!", messageInput: error?.localizedDescription ?? "Try again")
            }else{
                if snapshot?.isEmpty != true && snapshot?.isEmpty != nil{
                    self.tripsArray.removeAll()
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                        self.tripData = TravelNoteModel.init(JSON: [:])
                        
                        if let id = document.get("id") as? String {
                            self.tripData?.id = id
                        }
                        
                        if let url = document.get("photoUrl") as? String {
                            self.tripData?.photoUrl = url
                        }
                        
                        if let title = document.get("title") as? String {
                            self.tripData?.title = title
                            
                        }
                        if let user = document.get("user") as? [String: Any] {
                            let userData = UserModel(JSON: user)
                            self.tripData?.user = userData
                            
                        }
                        if let loc = document.get("location") as? [String: Any] {
                            let locData = CitiesModel(JSON: loc)
                            self.tripData?.location = locData
                            
                        }
                        if let note = document.get("note") as? String {
                            self.tripData?.note = note
                        }
                        if let date = document.get("date") as? Timestamp {
                            let date = date.dateValue()
                            self.tripData?.date = date.toStringDate()
                        }
                        if self.tripData?.id != nil{
                            self.tripsArray.append(self.tripData!)
                        }
                      
                    }
                    self.total = self.tripsArray.count ?? 0
                    if self.total > 0 {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.noDataView.isHidden = true
                    }else{
                        
                        self.tableView.isHidden = true
                        self.noDataView.isHidden = false
                    }

                }else{
                   
                    self.tableView.isHidden = true
                    self.noDataView.isHidden = false
                }
              
            }
            
   
        }
    
    }
}
