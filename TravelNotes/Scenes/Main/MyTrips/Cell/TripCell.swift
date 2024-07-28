//
//  TripCell.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 31.12.2023.
//

import UIKit
import SDWebImage

class TripCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var locationStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configCell(data: TravelNoteModel){
        self.profileImage.sd_setImage(with: URL(string: data.user?.profile_photo ?? ""))
        if data.location?.name != nil || data.location?.name != "" {
            self.locationStack.isHidden = false
            self.locLabel.text = data.location?.name ?? ""
        }
        if data.location?.name == ""{
            self.locationStack.isHidden = true
        }
       
        self.titleLabel.text = data.title ?? ""
        self.noteLabel.text = data.note ?? ""
        self.photoView.sd_setImage(with: URL(string: data.photoUrl ?? ""))
        self.dateLabel.text = data.date ?? "-"
        self.nameLabel.text = (data.user?.first_name ?? "-") + " " + (data.user?.last_name ?? "-")
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        self.favButton.isSelected = !self.favButton.isSelected
        
    }
    
    @IBAction func starButtonClicked(_ sender: UIButton) {
        self.starButton.isSelected = !self.starButton.isSelected
        
    }
}
