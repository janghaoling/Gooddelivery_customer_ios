//
//  SignInViewController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController {
    
    
    //MARK: Declaration.
    @IBOutlet weak var connectWithSocialLbl: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var signInBut: UIButton!
    @IBOutlet weak var mobileNumberTxtFlb: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var backBut: UIButton!
    @IBOutlet weak var passwordBut: UIButton!
    @IBOutlet weak var accountBut: UIButton!
    private var userInfo : UserData?
    @IBOutlet weak var forgetPasswordBut: UIButton!
    private var getOTP: GetOTP?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    fileprivate var socialLogin = SocialLoginHelper ()
    
    let facebook = "fb"
    let google = "google"
    
    
    //MARK: View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mobileNumberTxtFlb.keyboardType = .numberPad
        passwordTxtFld.keyboardType = .asciiCapable
        hideKeyboardWhenTappedAround()
        
        countryCodeLbl.text = APPLocalize.localizestring.countryNumber
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+APPLocalize.localizestring.countryCode)
        
        localize()
        design()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    func localize() {
        
        self.mobileNumberTxtFlb.placeholder = APPLocalize.localizestring.MobileNumber.localize()
        self.passwordTxtFld.placeholder =  APPLocalize.localizestring.password.localize()
        self.connectWithSocialLbl.text =  APPLocalize.localizestring.copnnectWithSocial.localize()

        self.accountBut.setTitle( APPLocalize.localizestring.dontHaveAccount.localize(), for: .normal)
        self.forgetPasswordBut.setTitle(APPLocalize.localizestring.forgetPassword.localize(), for: .normal)
        self.signInBut.setTitle(APPLocalize.localizestring.signIn.localize(), for: .normal)
        
    }
    
    func design() {
        
        Common.setFont(to: mobileNumberTxtFlb, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: passwordTxtFld, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: countryCodeLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: accountBut, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: forgetPasswordBut, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: connectWithSocialLbl, isTitle: true, size: 18, fontType: .semiBold)
        Common.setFont(to: signInBut, isTitle: true, size: 18, fontType: .semiBold)
    }
    
    //MARK: Button Actions.
    @IBAction func loginViaGoogle(_ sender: UIButton) {
        socialLogin.loginThroughGoogle(fromViewController: self, helperDelegate: self)
    }
    @IBAction func loginViafaceBook(_ sender: UIButton) {
        
        // socialLogin.loginThroughFacebook(fromViewController: self, helperDelegate: self)
        
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
            print(FBSDKAccessToken.current()?.tokenString)
            
            UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: Keys.list.socialLoginAccessToken)
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil)
                {
                    let userDetail = result as! [String : AnyObject]
                    
                    let facebookUserDetail = FacebookUserDetail(dictionary: userDetail)
                    
                    // let fbResult = result as! NSDictionary
                    
                    var loginReqData = LoginRequestData()
                    loginReqData.login_by = .facebook
                    loginReqData.accessToken = UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String
                    
                    self.presenter?.post(api: .socialLogin, data: loginReqData.toData())
                    
                }
            })
        }
    }
    
    @IBAction func backToPreviousScreen(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let mobileVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.MobileViewController) as! MobileViewController
        mobileVC.isFromForgetPassword = true
        self.navigationController?.pushViewController(mobileVC, animated: true)
    }
    
    @IBAction func accountRedirection(_ sender: UIButton) {
        
        let mobileVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.MobileViewController) as! MobileViewController
        self.navigationController?.pushViewController(mobileVC, animated: true)
    }
    
    @IBAction func signInClickEvent(_ sender: UIButton) {
        
        guard let mobileNumber = mobileNumberTxtFlb.text, !mobileNumber.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterPhoneNumber.localize())
            return
        }
        guard mobileNumberTxtFlb.text?.count ?? 0 > 7 else {
            self.showToast(string: ErrorMessage.list.inValidPhoneNumber.localize())
            
            return
        }
        guard mobileNumberTxtFlb.text?.count ?? 0 < 15 else {
            self.showToast(string: ErrorMessage.list.inValidPhoneNumber.localize())
            
            return
        }
        
        guard let countryCode = countryCodeLbl.text, !countryCode.isEmpty else {
            self.showToast(string: ErrorMessage.list.EnterCountry.localize())
            return
        }
        
        guard let password = passwordTxtFld.text, !password.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterPassword.localize())
            return
        }
        
        self.loader.isHidden = false
        var loginRequestData = LoginRequestData()
        loginRequestData.grant_type = WebConstants.string.password
        loginRequestData.username = countryCodeLbl.text! + mobileNumberTxtFlb.text!
        loginRequestData.password = passwordTxtFld.text
        loginRequestData.client_id = appClientId
        loginRequestData.client_secret = appSecretKey
        print(loginRequestData)
        self.presenter?.post(api: .login, data: loginRequestData.toData())
        //self.presenter?.post(api: .login, data: MakeJson.login(withUser: countryCodeLbl.text! + mobileNumberTxtFlb.text!, password: passwordTxtFld.text!))
        
    }
    
    @IBAction func openCountryPicker(_ sender: UIButton) {
        
        let countryPicker =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CountryCodeController) as! CountryCodeController
        countryPicker.countryDelegate = self
        self.present(countryPicker, animated: true, completion: nil)
    }
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTxtFld.isSecureTextEntry = !passwordTxtFld.isSecureTextEntry
        let image = UIImage(named: passwordTxtFld.isSecureTextEntry ? "eye" : "eyeoff")
        sender.setBackgroundImage(image, for: .normal)
        sender.tag = 0
        
    }
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
}

// MARK: Country Delegate

extension SignInViewController: countryDelegate {
    
    func didReceiveUserCountryDetails(countryDetails: Country?) {
        
        countryCodeLbl.text = String(describing: (countryDetails?.dial_code)!)
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+(countryDetails?.code)!)
        
    }
}



// MARK: - PostViewProtocol
extension SignInViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        self.showToast(string: message)
    }
    
    func getOath(api: Base, data: LoginRequestData?) {
        
        if api == .login, let accessToken = data?.access_token {
            User.main.accessToken = accessToken
            User.main.refreshToken = data?.refresh_token
            
            self.loader.isHidden = true
            storeInUserDefaults()
            self.showToast(string: APPLocalize.localizestring.loginSuccess.localize())
            appDelegate.isSkip = false
            let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController) 
            self.navigationController?.pushViewController(baseHomeVC, animated: true)
            
        } else if api == .socialLogin , let accessToken = data?.access_token {
            
            User.main.accessToken = accessToken
            User.main.refreshToken = data?.refresh_token
            
            self.loader.isHidden = true
            storeInUserDefaults()
            appDelegate.isSkip = false
            self.showToast(string: APPLocalize.localizestring.loginSuccess.localize())
            let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
            self.navigationController?.pushViewController(baseHomeVC, animated: true)
            
        }
    }
    
}


//MARK: Textfield Delegate
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - Social login helper delegate methods

extension SignInViewController: SocialLoginHelperDelegate {
    
    func didReceiveFacebookLoginUser(detail: FacebookUserDetail) {
        
        
        self.userInfo = UserData()
        userInfo?.accessToken = FBSDKAccessToken.current().tokenString
        userInfo?.login_by = .facebook
        self.presenter?.post(api: .socialLogin, data: userInfo?.toData())
        
    }
    
    func didReceiveGoogleLoginUser(detail: GIDGoogleUser) {
        
        
        
        var loginRequestData = LoginRequestData()
        loginRequestData.login_by = .google
        loginRequestData.accessToken = detail.authentication.accessToken
        
        self.presenter?.post(api: .socialLogin, data: loginRequestData.toData())
        
    }
    
    func didReceiveFacebookLoginError(message: String) {
        
    }
    
    func didReceiveGoogleLoginError(message: String) {
        
    }
    
}
