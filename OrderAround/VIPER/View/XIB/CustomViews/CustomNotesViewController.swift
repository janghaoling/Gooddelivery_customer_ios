//
//  CustomNotesViewController.swift
//  orderAround
//
//  Created by Deepika on 16/11/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class CustomNotesViewController: UIViewController {

   
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var addCustomLb: UILabel!
    var delegate: CustomNotesDelegate?
    var customNote = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        localize()
        setFont()
        addCustomLb.textColor = UIColor.orangeprimary
        submitButton.backgroundColor = UIColor.orangeprimary
        textView.text = customNote
        submitButton.addTarget(self, action: #selector(submitCustomNote), for: .touchUpInside)
    }


    func localize() {
        
        submitButton.setTitle(APPLocalize.localizestring.submit.localize(), for: .normal)
         addCustomLb.text = APPLocalize.localizestring.customNotes.localize()
    }
    
    func setFont() {
        
        Common.setFont(to: addCustomLb, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: submitButton, isTitle: true, size: 15, fontType: .semiBold)
        Common.setFont(to: textView, isTitle: true, size: 14, fontType: .regular)
    }
    

}


extension CustomNotesViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
       // textView.text = nil
        textView.textColor = UIColor.black
        
    }
    
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}


extension CustomNotesViewController {
    
    @objc func submitCustomNote(sender: UIButton) {

        
        if textView.text.isEmpty {
            customNote = Constants.string.empty
        } else {
            customNote = self.textView.text!
        }
        
        dismiss(animated:true, completion: { [weak self] in
            self?.delegate?.didReceiveCustomNotes(isNoteAdded: true, customNotes: self!.customNote)
        })
    }
}
