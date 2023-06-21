//
//  AddWalletAmount.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class AddWalletAmount: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var enterAmount: UITextField!
    @IBOutlet weak var enterAmountLabel: UILabel!
    weak var delegate: AddAmountViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        enterAmount.delegate = self
        // Initialization code
        enterAmountLabel.text = APPLocalize.localizestring.enterAmount.localize().uppercased()
        self.addToolBarTextField(textField: enterAmount
        )
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.showEnterAmount(enterAmountValue: enterAmount.text ?? "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addToolBarTextField(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.primary
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIViewController.dismissKeyboard))
        toolBar.setItems([flexButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    @objc func dismissKeyboard() {
        enterAmount.endEditing(true)
    }
    
}
// MARK: - Protocol for set Value for DateWise Label
protocol AddAmountViewControllerDelegate: class {
    func showEnterAmount(enterAmountValue: String)
}
