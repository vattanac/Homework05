//
//  TableViewCell.swift
//  AlamofireAPIWithTableView
//
//  Created by Vattanac on 12/15/18.
//  Copyright © 2018 vattanac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var ImageArticle: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var authorArticle: UILabel!
    @IBOutlet weak var desArticle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
