//
//  CountryCodeCell.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    @IBOutlet weak var flagImg: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    //MARK:- Setting Values in Cell From Country Object
    
    func set(values : Country) {
        
        self.flagImg.image = UIImage(named: "CountryPicker.bundle/"+values.code)
        self.countryLbl.text = values.name//values.name
        self.countryCodeLbl.text = String(describing: values.dial_code) //"(\(values.dial_code))"+values.name +
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
