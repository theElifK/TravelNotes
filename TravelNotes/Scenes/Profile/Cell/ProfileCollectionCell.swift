//
//  ProfileCollectionCell.swift
//  TravelNotes
//
//  Created by Elif Karakolcu on 28.05.2024.
//

import UIKit
class ProfileCollectionCell: UICollectionViewCell {

    @IBOutlet weak var tripImage: UIImageView!
  
    var travelData: TravelNoteModel?
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func configCell(travelData: TravelNoteModel?){
        self.travelData = travelData
        self.tripImage.sd_setImage(with: URL(string: travelData?.photoUrl ?? ""))
    }
    
}

