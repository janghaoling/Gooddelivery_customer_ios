//
//  AddNewCardViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import Stripe

class AddNewCardViewController: UIViewController {

    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardNumberTxtFld: UITextField!
    @IBOutlet weak var vaildTxtFld: UITextField!
    @IBOutlet weak var cvvTxtFld: UITextField!
    @IBOutlet weak var cardDividerLine: UIView!
    @IBOutlet weak var cvvDividerLine: UIView!
    @IBOutlet weak var vaildDateDividerLine: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    
    var userCartInfo: UserCardInfo?
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    var mm = Int()
    var yyyy = Int()
    var delegate: CardDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        titleLbl.text = APPLocalize.localizestring.addCard.localize()
        cardNumberTxtFld.placeholder = APPLocalize.localizestring.cardNumber.localize()
        cvvTxtFld.placeholder = APPLocalize.localizestring.cvv.localize()
        vaildTxtFld.placeholder = APPLocalize.localizestring.vaildThiru.localize()
   addButton.setTitle(APPLocalize.localizestring.add.localize(), for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    

    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.delegate?.didReceiveCartDetail(isUpdate: false, cartDetail: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
   
    
    @IBAction func addCartClickEvent(_ sender: Any) {
        self.view.endEditingForce()
        if cardNumberTxtFld.text == "" {
            
        }
        guard let cardNumberError = self.cardNumberTxtFld.text, !cardNumberError.isEmpty else {
            self.showToast(string: ErrorMessage.list.cardNumber.localize())
            return
        }
        
        guard let date = vaildTxtFld.text, !date.isEmpty else {
            self.showToast(string: ErrorMessage.list.ValidityDate.localize())
            return
        }
        guard let cvv = cvvTxtFld.text, !cvv.isEmpty else {
            self.showToast(string: ErrorMessage.list.cvvNumber.localize())
            return
        }
        self.loader.isHidden = false
        
        let cardNumber = cardNumberTxtFld.text?.replacingOccurrences(of: " ", with: "")
        let dataStr = vaildTxtFld.text?.components(separatedBy: "-")
        mm = Int((dataStr?.first)!)!
        yyyy = Int((dataStr?.last)!)!
        
       
        let cardParam = STPCardParams()
        cardParam.cvc = cvvTxtFld.text!
        cardParam.expYear = UInt(yyyy)
        cardParam.number = cardNumber
        cardParam.expMonth = UInt(mm)
        
        STPAPIClient.shared().createToken(withCard: cardParam) { (stpToken, error) in
            
            if stpToken?.tokenId != nil {
            var cardEntity = UserCardInfo()
            cardEntity.stripe_token = stpToken?.tokenId
            self.presenter?.post(api: .cardDetail, data: cardEntity.toData())
            }
        }
        
    }
    
}

// MARK: UITextFieldDelegate

extension AddNewCardViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == cardNumberTxtFld {
            
            if range.location == 19 {
                
                return false
            }
            
            if string.count == 0 {
                
                return true
            }
            
            if range.location == 4 || range.location == 9 || range.location == 14
            {
                
                let str = textField.text! + " "
                cardNumberTxtFld.text   = str
            }
            
        } else if textField == vaildTxtFld {
            
            if range.location == 5 {
                
                return false
            }
            
            if string.count == 0 {
                
                return true
            }
            
            if range.location == 2  {
                
                 let str = textField.text! + "-"
                 vaildTxtFld.text = str
            }
            
        }  else if textField == cvvTxtFld {
            
            if range.location == 4 {
                
                return false
            }
            
            if string.count == 0 {
                
                return true
            }
        }
            
       return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension AddNewCardViewController: PostViewProtocol {
    
    
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
       
    }
    
    func getCardDetails(api: Base, data: [Card]?, msg: Message?) {
        
        if api == .cardDetail, data != nil {
            
            self.loader.isHidden = true
           
        }
        
        if api == .cardDetail, msg != nil {
          
            DispatchQueue.main.async {
                self.loader.isHidden = true
                let alert = showAlert(message: msg?.message) { (_) in
                    self.delegate?.didReceiveCartDetail(isUpdate: true, cartDetail: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
    }

}



