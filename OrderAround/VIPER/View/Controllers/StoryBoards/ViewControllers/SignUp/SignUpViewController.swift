//
//  SignUpViewController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

   
    // MARK: - Declarations.
    @IBOutlet weak var signInLbl: UILabel!
    @IBOutlet weak var alreadyLbl: UILabel!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var confirmPasswordEyeBut: UIButton!
    @IBOutlet weak var passwordEyeButton: UIButton!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    private var userInfo : UserData?
    var  name: String?
    var  accessToken: String?
    @IBOutlet weak var registerBut: UIButton!
    var  email: String?
    var  login_by: String?
    var phoneNumber: Int?
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    // MARK: - ViewLifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localize()
        setCustomFont()
        hideKeyboardWhenTappedAround()

        confirmPassword.isSecureTextEntry = true
        passwordTxtFld.isSecureTextEntry = true
        checkForDeviceToEnableScroll()
       
        if login_by == LoginType.google.rawValue || login_by == LoginType.facebook.rawValue {
            
            emailTxtFld.text = email!
            userNameTxtFld.text = name!
            emailTxtFld.isUserInteractionEnabled = false
            userNameTxtFld.isUserInteractionEnabled = false
            
        } else {
            
            emailTxtFld.isUserInteractionEnabled = true
            userNameTxtFld.isUserInteractionEnabled = true
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    func localize() {
        
        registerBut.setTitle(APPLocalize.localizestring.register.localize(), for: .normal)
        userNameTxtFld.placeholder = APPLocalize.localizestring.name.localize()
        emailTxtFld.placeholder = APPLocalize.localizestring.emailAddress.localize()
        passwordTxtFld.placeholder = APPLocalize.localizestring.password.localize()
        confirmPassword.placeholder = APPLocalize.localizestring.confirmPassword.localize()
        alreadyLbl.text = APPLocalize.localizestring.alreadyHaveAccount.localize()
        signInLbl.text = APPLocalize.localizestring.signInHere.localize()
    }
    
    func setCustomFont() {
        Common.setFont(to: registerBut, isTitle: true, size: 18, fontType: .semiBold)
        Common.setFont(to: signInLbl, isTitle: true, size: 14, fontType: .semiBold)
        Common.setFont(to: userNameTxtFld, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: emailTxtFld, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: passwordTxtFld, isTitle: true, size: 14, fontType: .regular)
        Common.setFont(to: confirmPassword, isTitle: true, size: 14, fontType: .regular)
        
    }
    
    
    // MARK: - CheckForDeviceToEnableScroll
    
    func checkForDeviceToEnableScroll() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                scrollView.isScrollEnabled = true
            case 1334:
                scrollView.isScrollEnabled = false
            case 1920, 2208:
                scrollView.isScrollEnabled = false
            case 2436:
                scrollView.isScrollEnabled = false
            default:
                scrollView.isScrollEnabled = false
            }
        }
    }
   
    // MARK: - Button Actions
    
    //Back button action
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
     //showPassword
    @IBAction func showPassword(_ sender: UIButton) {
        
        if sender.tag == 888 {
            confirmPassword.isSecureTextEntry = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "eyeoff"), for: .normal)
            sender.tag = 0
        } else {
            confirmPassword.isSecureTextEntry = true
            confirmPasswordEyeBut.tag = 888
            confirmPasswordEyeBut.setBackgroundImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
     // showConfirmPassword
    @IBAction func showConfirmPassword(_ sender: UIButton) {
        if sender.tag == 999 {
            passwordTxtFld.isSecureTextEntry = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "eyeoff"), for: .normal)
            sender.tag = 0
        } else {
            passwordTxtFld.isSecureTextEntry = true
            passwordEyeButton.tag = 999
            passwordEyeButton.setBackgroundImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
     //redirectToSignIn
    @IBAction func redirectToSignIn(_ sender: UIButton) {
        let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
        self.navigationController?.pushViewController(signIn, animated: true)
        
    }
    
    //signUpClickEvent
    @IBAction func signUpClickEvent(_ sender: UIButton) {
        
        self.view.endEditingForce()
        
        guard let email = self.validateEmail() else { return }
        
        guard let userName = self.userNameTxtFld.text, !userName.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterName.localize())
            return
        }
        
        guard let password = passwordTxtFld.text, !password.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterPassword.localize())
            return
        }
        guard let confirmPwd = confirmPassword.text, !confirmPwd.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterConfirmPassword.localize())
            return
        }
        guard confirmPwd == password else {
            self.showToast(string: ErrorMessage.list.passwordDonotMatch.localize())
            return
        }
        
        if login_by == "google"  {
            
               if (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String) != nil {
                //userInfo =  MakeJson.signUpViaSocial(loginBy: .google, email: String(describing: email), userName: String(describing: name!), phone: phoneNumber, accessToken: (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String)!)
                var userDetailInfo = UserProfile()
                userDetailInfo.email = String(describing: email)
                let phone = String(phoneNumber!)
                if !phone.contains("+") {
                    userDetailInfo.phone = "+" + phone
                }else{
                    userDetailInfo.phone = phone
                }
                userDetailInfo.accessToken = (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String)!
                userDetailInfo.login_by = .google
                userDetailInfo.name = String(describing: name!)
                self.loader.isHidden = false
                self.presenter?.post(api: .signUp, data: userDetailInfo.toData())
            }
            
        } else if login_by == "fb" {
            
             if (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String) != nil {
               // userInfo =  MakeJson.signUpViaSocial(loginBy: .fb, email: String(describing: email), userName: String(describing: name!), phone: phoneNumber, accessToken: (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String)!)
                var userDetailInfo = UserProfile()
                userDetailInfo.email = String(describing: email)
                let phone = String(phoneNumber!)
                if !phone.contains("+") {
                    userDetailInfo.phone = "+" + phone
                }else{
                    userDetailInfo.phone = phone
                }
                userDetailInfo.accessToken = (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String)!
                userDetailInfo.login_by = .facebook
                userDetailInfo.password = password
                userDetailInfo.password_confirmation = confirmPwd
                userDetailInfo.name = String(describing: name!)
                self.loader.isHidden = false
                self.presenter?.post(api: .signUp, data: userDetailInfo.toData())
            }
            
            
        } else {
            var userDetailInfo = UserProfile()
            userDetailInfo.email = email
            let phone = String(phoneNumber!)
            if !phone.contains("+") {
              userDetailInfo.phone = "+" + phone
            }else{
                userDetailInfo.phone = phone
            }
            
            userDetailInfo.password = password
            userDetailInfo.password_confirmation = confirmPwd
            userDetailInfo.name = userName
            
            self.loader.isHidden = false
            print(userDetailInfo)
            self.presenter?.post(api: .signUp, data: userDetailInfo.toData())
            
        }
    }
    
    private func validateEmail()->String? {
        guard let email = emailTxtFld.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterEmail.localize())
            emailTxtFld.becomeFirstResponder()
            return nil
        }
        guard Common.isValid(email: email) else {
            self.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            emailTxtFld.becomeFirstResponder()
            return nil
        }
        return email
    }
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }

}
    


// MARK: - TextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - PostViewProtocol
extension SignUpViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        User.main.accessToken = Constants.string.empty
        self.showToast(string: message)
    }
    
    func signUp(api: Base, response: UserProfile?) {
        
        if api == .signUp, response != nil {
            
//            Common.storeUserData(from: response)
            storeInUserDefaults()
            if login_by == "fb"  {
                
                if (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String) != nil {
                    
                    var loginReqData = LoginRequestData()
                    loginReqData.login_by = .facebook
                    loginReqData.accessToken = UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String
                    
                    self.presenter?.post(api: .socialLogin, data: loginReqData.toData())
                }
                
            } else if login_by == "google" {
               
                  if (UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String) != nil {
                    
                    var loginRequestData = LoginRequestData()
                    loginRequestData.login_by = .google
                    loginRequestData.accessToken = UserDefaults.standard.value(forKey: Keys.list.socialLoginAccessToken) as? String

                    self.presenter?.post(api: .socialLogin, data: loginRequestData.toData())
                }
               
        }else {
                var loginRequestData = LoginRequestData()
                loginRequestData.grant_type = WebConstants.string.password
                let phone = String(phoneNumber!)
                if !phone.contains("+") {
                    loginRequestData.username = "+" + phone
                }else{
                    loginRequestData.username = phone
                }
                loginRequestData.password = passwordTxtFld.text
                loginRequestData.client_id = appClientId
                loginRequestData.client_secret = appSecretKey
                print(loginRequestData)
                self.presenter?.post(api: .login, data: loginRequestData.toData())
            }
            
        }
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
        } else if api == .socialLogin, let accessToken = data?.access_token {
            User.main.accessToken = accessToken
            User.main.refreshToken = data?.refresh_token
            self.loader.isHidden = true
            storeInUserDefaults()
            self.showToast(string: APPLocalize.localizestring.loginSuccess.localize())
             appDelegate.isSkip = false
            let baseHomeVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.BaseTabController)
            self.navigationController?.pushViewController(baseHomeVC, animated: true)
        }
    }
    
}


