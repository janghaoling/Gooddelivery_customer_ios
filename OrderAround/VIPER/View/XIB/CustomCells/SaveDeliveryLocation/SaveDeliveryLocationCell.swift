//
//  SaveDeliveryLocationCell.swift
//  Project
//
//  Created by CSS on 23/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class SaveDeliveryLocationCell: UITableViewCell {
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var othersTxtFLd: UITextField!
    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var homeLbl: UILabel!
    @IBOutlet weak var othersLbl: UILabel!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var workBut: UIButton!
    @IBOutlet weak var homeBut: UIButton!
    @IBOutlet weak var othersBut: UIButton!
    @IBOutlet weak var saveAndProceedBut: UIButton!
    @IBOutlet weak var saveLbl: UILabel!
    @IBOutlet weak var homeSelectedImg: UIImageView!
    @IBOutlet weak var othersSelected: UIImageView!
    @IBOutlet weak var workSelectedImg: UIImageView!
    
    @IBOutlet weak var locationTypeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        localize()
        setCustomFont()
    }

    func localize() {
        homeLbl.text = APPLocalize.localizestring.home.localize()
        workLbl.text = APPLocalize.localizestring.work.localize()
        othersLbl.text = APPLocalize.localizestring.others.localize()
        saveLbl.text = APPLocalize.localizestring.saveAs.localize()
        saveAndProceedBut.setTitle(APPLocalize.localizestring.saveAndProceed.localize(), for: .normal)
        
        homeBut.setTitle(APPLocalize.localizestring.home.localized, for: .normal)
        workBut.setTitle(APPLocalize.localizestring.work.localized, for: .normal)
        othersBut.setTitle(APPLocalize.localizestring.others.localized, for: .normal)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        homeBut.centerVertically(padding: 0)
        workBut.centerVertically()
        othersBut.centerVertically()
    }
    func setCustomFont() {
        
        Common.setFont(to: saveAndProceedBut, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: saveLbl, isTitle: true, size: 12, fontType: .light)
        Common.setFont(to: othersLbl, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: workLbl, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: homeLbl, isTitle: true, size: 12, fontType: .regular)
        
        Common.setFont(to: homeBut, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: workBut, isTitle: true, size: 12, fontType: .regular)
        Common.setFont(to: othersBut, isTitle: true, size: 12, fontType: .regular)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}


