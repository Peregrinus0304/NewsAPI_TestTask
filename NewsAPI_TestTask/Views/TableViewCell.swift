//
//  TableViewCell.swift
//  NewsAPI_TestTask
//
//  Created by TarasPeregrinus on 12.04.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    //MARK: - IBOutlet
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSourceLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDescriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
           super.layoutSubviews()
           //set the values for top,left,bottom,right margins
           let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
           contentView.frame = contentView.frame.inset(by: margins)
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
