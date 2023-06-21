//
//  CustomNotesCell.swift
//  Project
//
//  Created by CSS on 22/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CustomNotesCell: UITableViewCell {

    @IBOutlet weak var customNotesLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Common.setFont(to: customNotesLbl, isTitle: true, size: 14, fontType: .regular)
        customNotesLbl.text = APPLocalize.localizestring.customNotes.localize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
