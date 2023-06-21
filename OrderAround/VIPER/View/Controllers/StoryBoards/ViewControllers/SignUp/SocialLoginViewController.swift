//
//  SocialLoginViewController.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SocialLoginViewController: UIViewController {
    
    
    //MARK: Declaration.
   
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var mobileNumberTxtFlb: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var backBut: UIButton!
    fileprivate var socialLogin = SocialLoginHelper ()
    var  name: String?
    var  accessToken: String?
    var  email: String?
    var  login_by: String?
    private var userInfo : UserData?
    var otp: String?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var alreadyBut: UIButton!
    
    let facebook = "fb"
    let google = "google"
    private var verifyOTP : GetOTP?
    
    //MARK: View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLoads()
        hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
   
    
    //MARK: Button Actions.
    @IBAction func loginViaGoogle(_ sender: UIButton) {
        socialLogin.loginThroughGoogle(fromViewController: self, helperDelegate: self)
    }
    @IBAction func loginViafaceBook(_ sender: UIButton) {
      //  socialLogin.loginThroughFacebook(fromViewController: self, helperDelegate: self)
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil)
            {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil
                {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            print(FBSDKAccessToken.current()?.tokenString as Any)
            
            UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: Keys.list.socialLoginAccessToken)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil)
                {
                    let userDetail = result as! [String : AnyObject]
                    let facebookUserDetail = FacebookUserDetail(dictionary: userDetail)
       
                }
            })
        }
    }
    
    
    @IBAction func backToPreviousScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonEvent(_ sender: UIButton) {
        
        guard let mobileNumber = mobileNumberTxtFlb.text, !mobileNumber.isEmpty else {
            Common.showToast(string: ErrorMessage.list.enterPhoneNumber.localize())
            return
        }
        guard mobileNumberTxtFlb.text?.count ?? 0 > 7 else {
            Common.showToast(string: ErrorMessage.list.inValidPhoneNumber.localize())

            return
        }
        guard mobileNumberTxtFlb.text?.count ?? 0 < 15 else {
            Common.showToast(string: ErrorMessage.list.inValidPhoneNumber.localize())

            return
        }
        
        guard let countryCode = countryCodeLbl.text, !countryCode.isEmpty else {
            Common.showToast(string: ErrorMessage.list.EnterCountry.localize())
            return
        }
        
        self.view.endEditingForce()
        self.loader.isHidden = false
        self.verifyOTP = GetOTP()
        self.verifyOTP?.phone = countryCodeLbl.text! + mobileNumberTxtFlb.text!
        self.presenter?.post(api: .getOTP, data: self.verifyOTP?.toData())
    
    }
    
    @IBAction func accountReDirect(_ sender: UIButton) {
        let mobileVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.MobileViewController) as! MobileViewController
        self.navigationController?.pushViewController(mobileVC, animated: true)
    }
    
    @IBAction func openCountryPicker(_ sender: Any) {
        
        let countryPicker =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CountryCodeController) as! CountryCodeController
        countryPicker.countryDelegate = self
        self.present(countryPicker, animated: true, completion: nil)
    }
    
}

extension SocialLoginViewController {
    private func initialLoads() {
        localize()
        setCustomFont()
        
        emailTxtFld.text = email
        nameTxtFld.text = name
        
        emailTxtFld.isUserInteractionEnabled = false
        nameTxtFld.isUserInteractionEnabled = false
        mobileNumberTxtFlb.keyboardType = .numberPad
        
        countryCodeLbl.text = APPLocalize.localizestring.countryNumber
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+APPLocalize.localizestring.countryCode)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func localize() {
        
        nameTxtFld.placeholder = APPLocalize.localizestring.name.localize()
        emailTxtFld.placeholder = APPLocalize.localizestring.emailAddress.localize()
        mobileNumberTxtFlb.placeholder = APPLocalize.localizestring.mobileNumber.localize()
        nextBut.setTitle( APPLocalize.localizestring.next.localize(), for: .normal)
    }
    
    func setCustomFont() {
        
        Common.setFont(to: nextBut, isTitle: true, size: 18, fontType: .semiBold)
        Common.setFont(to: mobileNumberTxtFlb, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: emailTxtFld, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: nameTxtFld, isTitle: true, size: 14, fontType: .regular)
    }
    
}

// MARK: Country Delegate

extension SocialLoginViewController: countryDelegate {
    
    func didReceiveUserCountryDetails(countryDetails: Country?) {
        countryCodeLbl.text = String(describing: (countryDetails?.dial_code)!)
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+(countryDetails?.code)!)
    }
}

// MARK: - Social login helper delegate methods

extension SocialLoginViewController: SocialLoginHelperDelegate {
    
    func didReceiveFacebookLoginUser(detail: FacebookUserDetail) {
        
    }
    
    func didReceiveGoogleLoginUser(detail: GIDGoogleUser) {
        
    }
    
    func didReceiveFacebookLoginError(message: String) {
        print(message)
    }
    
    func didReceiveGoogleLoginError(message: String) {
        
    }
    
}


// MARK: - PostViewProtocol
extension SocialLoginViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        self.loader.isHidden = true
        Common.showToast(string: message)
        
    }
    
    func getOtp(api: Base, otp: OTP?) {
       
        if api == .getOTP {
            self.loader.isHidden = true
            let otpNumber = String(describing: (otp?.otp)!)
            let otp = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.VerificationViewController) as! VerificationViewController
            otp.set(mobile: countryCodeLbl.text! + mobileNumberTxtFlb.text! , otp: otpNumber)
            otp.accessToken = accessToken
            otp.email = emailTxtFld.text!
            otp.login_by = login_by
            otp.name = nameTxtFld.text!
            otp.phoneNumber = Int(countryCodeLbl.text! + mobileNumberTxtFlb.text!)!
            self.navigationController?.pushViewController(otp, animated: true)
            
        }
    }
}


//MARK: - UITextrfiled delegate
extension SocialLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
