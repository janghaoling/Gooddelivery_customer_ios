//
//  MobileViewController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit



class MobileViewController: UIViewController {
    
    //MARK: Declaration.
    
    @IBOutlet weak var connectWithSocial: UILabel!
    @IBOutlet weak var alreadyLbl: UIButton!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImg: UIImageView!
    @IBOutlet weak var signInBut: UIButton!
    @IBOutlet weak var mobileNumberTxtFlb: UITextField!
    var isFromForgetPassword = false
    private var userInfo : UserData?
    fileprivate var socialLogin = SocialLoginHelper ()
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    let facebook = "fb"
    let google = "google"
    var getOTP: GetOTP?
   
    //MARK: View Life Cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        
       localize()
       design()
        hideKeyboardWhenTappedAround()

        mobileNumberTxtFlb.keyboardType = .numberPad
        countryCodeLbl.text = APPLocalize.localizestring.countryNumber 
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+APPLocalize.localizestring.countryCode.localize())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    func localize() {
        self.mobileNumberTxtFlb.placeholder = APPLocalize.localizestring.MobileNumber.localize()
        self.alreadyLbl.setTitle(APPLocalize.localizestring.alreadyHaveAccount.localize(), for: .normal)
        self.connectWithSocial.text = APPLocalize.localizestring.copnnectWithSocial.localize()
        self.signInBut.setTitle( APPLocalize.localizestring.next.localize().uppercased(), for: .normal)
    }
    
    func design() {
        Common.setFont(to: mobileNumberTxtFlb, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: countryCodeLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: alreadyLbl, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: connectWithSocial, isTitle: true, size: 18, fontType: .semiBold)
        Common.setFont(to: signInBut, isTitle: true, size: 18, fontType: .semiBold)
    }
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
    
    //MARK: Button Actions.
    @IBAction func loginViaGoogle(_ sender: UIButton) {
        socialLogin.loginThroughGoogle(fromViewController: self, helperDelegate: self)
    }
    
    @IBAction func loginViafaceBook(_ sender: UIButton) {
//         socialLogin.loginThroughFacebook(fromViewController: self, helperDelegate: self)
        
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
            print(FBSDKAccessToken.current()?.tokenString! as Any)

            UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: Keys.list.socialLoginAccessToken)

            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if (error == nil)
                {
                    let userDetail = result as! [String : AnyObject]
                    
                    let facebookUserDetail = FacebookUserDetail(dictionary: userDetail)

                   // let fbResult = result as! NSDictionary
                    
                    let socialLogin = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SocialLoginViewController) as! SocialLoginViewController

                    socialLogin.accessToken = (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String)!
                    socialLogin.name = facebookUserDetail.name
                    socialLogin.email = facebookUserDetail.email
                    socialLogin.login_by = self.facebook
                    self.navigationController?.pushViewController(socialLogin, animated: true)
                    
                }
            })
        }
    }
  
    @IBAction func accountRedirection(_ sender: UIButton) {
        let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    @IBAction func signInClickEvent(_ sender: UIButton) {
        
        self.view.endEditingForce()
        
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
        UserDefaults.standard.set(countryCodeLbl.text! + mobileNumberTxtFlb.text!, forKey: Keys.list.mobile)
        self.view.endEditingForce()
        self.loader.isHidden = false
        self.getOTP = GetOTP()
        getOTP?.phone = countryCodeLbl.text! + mobileNumberTxtFlb.text!
        
        if isFromForgetPassword {
           
            self.presenter?.post(api: .forgetPassword, data: getOTP?.toData())
            
        } else {
           
            self.presenter?.post(api: .getOTP, data: self.getOTP?.toData())
        }
    }
    
    @IBAction func openCountryPicker(_ sender: UIButton) {
        let countryPicker =  Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.CountryCodeController) as! CountryCodeController
        countryPicker.countryDelegate = self
        self.present(countryPicker, animated: true, completion: nil)
    }
}


// MARK: Country Delegate

extension MobileViewController: countryDelegate {
    
    func didReceiveUserCountryDetails(countryDetails: Country?) {
        
        countryCodeLbl.text = String(describing: (countryDetails?.dial_code)!)
        countryFlagImg.image = UIImage(named: "CountryPicker.bundle/"+(countryDetails?.code)!)
        
    }
}

// MARK: - Social login helper delegate methods

extension MobileViewController: SocialLoginHelperDelegate {
    
//    func didReceiveFacebookLoginUser(detail: FacebookUserDetail) {
//
//
//
//            let socialLogin = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SocialLoginViewController) as! SocialLoginViewController
//            socialLogin.accessToken = FBSDKAccessToken.current().tokenString
//            socialLogin.name = detail.name
//            socialLogin.email = detail.email
//            socialLogin.login_by = facebook
//            self.navigationController?.pushViewController(socialLogin, animated: true)
//
//    }
    
    func didReceiveGoogleLoginUser(detail: GIDGoogleUser) {
        let socialLogin = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SocialLoginViewController) as! SocialLoginViewController
        socialLogin.accessToken = detail.authentication.idToken
        socialLogin.name = detail.profile.name
        socialLogin.email = detail.profile.email
        socialLogin.login_by = google
        self.navigationController?.pushViewController(socialLogin, animated: true)
    }
    
    func didReceiveFacebookLoginError(message: String) {
        
    }
    
    func didReceiveGoogleLoginError(message: String) {
        
    }
    
}

// MARK:  PostViewProtocol

extension MobileViewController: PostViewProtocol{
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
     func getOtp(api: Base, otp: OTP?) {
        self.loader.isHidden = true
        let verifyOTP = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.VerificationViewController) as! VerificationViewController
        verifyOTP.isFromForgetPassword = isFromForgetPassword
        verifyOTP.set(mobile: countryCodeLbl.text! + mobileNumberTxtFlb.text!, otp: String(describing: (otp?.otp)!))
        self.navigationController?.pushViewController(verifyOTP, animated: true)
    }
    
    func getOath(api: Base, data: LoginRequestData?) {
        
         if api == .socialLogin , let accessToken = data?.access_token {
          
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
    
    func getOTPForForgetPassword(api: Base, data: ForgotPasswordEntity?) {
        
        if api == .forgetPassword, let userId = data?.user?.id, let forgetPasswordOTP = data?.user?.otp {
            
            self.loader.isHidden = true
            let verifyOTP = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.VerificationViewController) as! VerificationViewController
            verifyOTP.isFromForgetPassword = isFromForgetPassword
            verifyOTP.set(mobile: countryCodeLbl.text! + mobileNumberTxtFlb.text!, otp: String(forgetPasswordOTP))
            verifyOTP.userId = userId
            self.navigationController?.pushViewController(verifyOTP, animated: true)
        }
    }    
}

//MARK: Textfield Delegate
extension MobileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
