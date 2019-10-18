//
//  UserViewCell.swift
//  SQLiteLearn
//
//  Created by Raju Dhumne on 15/09/19.
//  Copyright © 2019 Raju Dhumne. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func config(email: String,name: String) {
        self.emailLbl.text = email
        self.nameLbl.text = name
    }
}
