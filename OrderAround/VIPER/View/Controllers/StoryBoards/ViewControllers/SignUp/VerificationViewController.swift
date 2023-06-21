//
//  VerificationViewController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    @IBOutlet weak var backImage: UIButton!
    
    @IBOutlet weak var resentOTP: UIButton!
    @IBOutlet weak var otpLBL: UILabel!
    @IBOutlet private weak var textView1 : UITextField!
    @IBOutlet private weak var textView2 : UITextField!
    @IBOutlet private weak var textView3 : UITextField!
    @IBOutlet private weak var textView4 : UITextField!
    @IBOutlet private weak var textView6: UITextField!
    @IBOutlet private weak var textView5: UITextField!
    @IBOutlet private weak var labelVerficationString : UILabel!
    @IBOutlet private weak var labelVerficationCodeSentString : Label!
    @IBOutlet private weak var buttonContinue : UIButton!
    private lazy var textFieldsArray = [self.textView1,self.textView2,self.textView3,self.textView4,self.textView5,self.textView6]
    
    private var mobileNumber : String = .Empty
    var isFromForgetPassword = false
    var userId: Int?
    private var otp : String = .Empty
    private var verifyOTP : GetOTP?
    
    @IBOutlet weak var resentLbl: UILabel!
    @IBOutlet weak var didnotGetOtp: UILabel!
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    var  name: String?
    var  accessToken: String?
    var  email: String?
    var  login_by: String?
    var phoneNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        hideKeyboardWhenTappedAround()

        resentOTP.addTarget(self, action: #selector(resendOTPEvent), for: .touchUpInside)
        backImage .setImage(UIImage(named: "back")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        backImage.tintColor = UIColor.black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layouts()
    }
    @IBAction func onBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
}

extension VerificationViewController : UIViewStructure {
    
    func initalLoads() {
        self.design()
        self.localize()
        textFieldsArray.forEach { (textField) in
            
            textField?.delegate = self
            textField?.contentMode = .center
            textField?.textAlignment = .center
            textField?.addShadow(color: .lightGray, opacity: 1, offset: CGSize(width: 0.1, height: 0.1), radius: 10, rasterize: false, maskToBounds: true)
            textField?.addTarget(self, action: #selector(textViewDidChange(_:)), for: UIControlEvents.editingChanged)
        }
        self.view.dismissKeyBoardonTap()
      //  textView1.becomeFirstResponder()
        labelVerficationCodeSentString.textAlignment = .left
        self.buttonContinue.addTarget(self, action: #selector(self.buttonContinueAction), for: .touchUpInside)
    }
    
    func localize() {
   
        resentLbl.text = APPLocalize.localizestring.resentOTP.localize()
        didnotGetOtp.text = APPLocalize.localizestring.didNotGetOTP.localize()
        self.buttonContinue.setTitle(APPLocalize.localizestring.continueText.localize().uppercased(), for: .normal)
        self.labelVerficationString.text = APPLocalize.localizestring.verficationCode.localize()
        let textString = APPLocalize.localizestring.verficationSentText.localize()+" \(mobileNumber)"
        self.labelVerficationCodeSentString.text = textString
        self.labelVerficationCodeSentString.startLocation = (textString.count-" \(mobileNumber)".count)
        self.labelVerficationCodeSentString.length = " \(mobileNumber)".count
        self.labelVerficationCodeSentString.attributeColor = .secondary
        self.otpLBL.text = APPLocalize.localizestring.OTP.localize() + ":" + self.otp
    }
    
    func design() {
        
        Common.setFont(to: didnotGetOtp, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: resentLbl, isTitle: false, size: 14, fontType: .regular)
        Common.setFont(to: labelVerficationString, isTitle: true, size: 20, fontType: .black)
        labelVerficationString.textColor = .darkGray
        Common.setFont(to: labelVerficationCodeSentString, isTitle: false, size: 8, fontType: .light)
        labelVerficationCodeSentString.textColor = .gray
        Common.setFont(to: buttonContinue)
        Common.setFont(to: otpLBL)

    }
    
    func layouts() {
        
    }
    
    // Setting mobile number and from SignIn View Controller 3
    func set(mobile mobileNumber : String, otp : String) {
        self.mobileNumber = mobileNumber
        self.otp = otp
    }
}

// MARK:- Actions

extension VerificationViewController {
    
    @IBAction private func buttonContinueAction() {
        self.view.endEditingForce()
        guard let otp1 = textView1.text, !otp1.isEmpty,
              let otp2 = textView2.text, !otp2.isEmpty,
              let otp3 = textView3.text, !otp3.isEmpty,
              let otp4 = textView4.text, !otp4.isEmpty,
              let otp5 = textView5.text, !otp5.isEmpty,
              let otp6 = textView6.text, !otp6.isEmpty
        
            else {
            self.view.makeToast(APPLocalize.localizestring.enterOtp.localize())
            return
        }
        
        let otpString = otp1 + otp2 + otp3 + otp4 + otp5 + otp6
        
        if  otpString == self.otp {
            
            if login_by == "google"  || login_by == "fb" {
               
                let signUP = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignUpViewController) as! SignUpViewController
                signUP.accessToken = accessToken
                signUP.email = email
                signUP.login_by = login_by
                signUP.name = name
                signUP.phoneNumber = phoneNumber
                self.navigationController?.pushViewController(signUP, animated: true)
                
            } else if isFromForgetPassword {
                let changePassword = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.ForgotPasswordController) as! ForgotPasswordController
                changePassword.getForgetPasswordOTP(otp: Int(self.otp)!, id: userId!)
                self.navigationController?.pushViewController(changePassword, animated: true)
         }else {
            let signUP = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignUpViewController) as! SignUpViewController
                signUP.phoneNumber = Int(self.mobileNumber)!
            self.navigationController?.pushViewController(signUP, animated: true)
            }
        } else {
            
            self.view.makeToast(APPLocalize.localizestring.enterCorrectOTP.localize())
        }
    }
    
    @objc func resendOTPEvent() {
        
        self.view.endEditingForce()
        self.loader.isHidden = false
        self.verifyOTP = GetOTP()
        self.verifyOTP?.phone = self.mobileNumber
        self.presenter?.post(api: .getOTP, data: self.verifyOTP?.toData())
    }
}


// MARK:- UITextViewDelegate

extension VerificationViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.makeResponsive(textView: textView)
        
        if textView.text.count>1, var text = textView.text {
            text.removeFirst()
            textView.text = text
        }
    }
    
    
    @objc func textViewDidChange(_ textView: UITextField) {
        
     /*   if Int.val(val: textView.text?.count)>1, var text = textView.text {
            text.removeFirst()
            textView.text = text
        }
        
        if textView.text.count>=1 {
            
            switch textView {
                
            case textView1 :
                textView2.becomeFirstResponder()
            case textView2 :
                textView3.becomeFirstResponder()
            case textView3 :
                textView4.becomeFirstResponder()
            case textView4 :
                textView5.becomeFirstResponder()
            case textView5 :
                textView6.becomeFirstResponder()
            default :
                textView.resignFirstResponder()
                
            }
        }*/
        switch textView.tag {
        case 0:
            if textView2.text?.count ?? 0 > 0 {return}
            textView2.becomeFirstResponder()
        case 1:
            if textView3.text?.count ?? 0 > 0 {return}
            textView3.becomeFirstResponder()
        case 2:
            if textView4.text?.count ?? 0 > 0 {return}
            textView4.becomeFirstResponder()
        case 3:
            if textView5.text?.count ?? 0 > 0 {return}
            textView5.becomeFirstResponder()
        case 4:
            if textView6.text?.count ?? 0 > 0 {return}
            textView6.becomeFirstResponder()
        case 5:
            textView6.resignFirstResponder()
            
        default:
            textView6.resignFirstResponder()
        }
    }
    
    private func makeResponsive(textView : UITextView){
        textFieldsArray.forEach { (field) in
            field?.layer.masksToBounds = !(textView == field)
        }
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
}

// MARK:  PostViewProtocol

extension VerificationViewController: PostViewProtocol{
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
    func getOtp(api: Base, otp: OTP?) {
        self.loader.isHidden = true
        textFieldsArray.forEach { (textField) in
            
            textField?.text = Constants.string.empty
        }
        self.otp = String(describing: (otp?.otp)!)
        self.otpLBL.text = APPLocalize.localizestring.OTP.localize() + ":" + String(describing: (otp?.otp)!)
    }
    
}

extension VerificationViewController: UITextFieldDelegate {
    
    func textFieldDidChange(textField: UITextField){
        
        switch textField.tag {
        case 0:
            if textView2.text?.count ?? 0 > 0 {return}
            textView1.becomeFirstResponder()
        case 1:
            if textView3.text?.count ?? 0 > 0 {return}
            textView2.becomeFirstResponder()
        case 2:
            if textView4.text?.count ?? 0 > 0 {return}
            textView3.becomeFirstResponder()
        case 3:
            if textView5.text?.count ?? 0 > 0 {return}
            textView4.becomeFirstResponder()
        case 4:
            if textView6.text?.count ?? 0 > 0 {return}
            textView5.becomeFirstResponder()
        case 5:
             textView6.resignFirstResponder()
        
        default:
             textView6.resignFirstResponder()
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

}
