//
//  ForgotPasswordController.swift
//  Project
//
//  Created by CSS on 09/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {

    //MARK: Declarations
    @IBOutlet weak var alreadyLbl: UILabel!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newpasswordShowBut: UIButton!
    @IBOutlet weak var signInHere: UILabel!
    @IBOutlet weak var confirmPasswordShowBut: UIButton!
    var userId: Int?
   
    private var userInfo: UserData?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    @IBOutlet weak var changeBut: UIButton!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        localize()
        setCustomFont()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    
    func localize() {
        alreadyLbl.text = APPLocalize.localizestring.alreadyHaveAccount.localize()
        signInHere.text = APPLocalize.localizestring.signInHere.localize()
        newPassword.placeholder = APPLocalize.localizestring.newPassword.localize()
        confirmPassword.placeholder = APPLocalize.localizestring.confirmPassword.localize()
        changeBut.setTitle( APPLocalize.localizestring.change.localize(), for: .normal)
    }
    
    func setCustomFont() {
         Common.setFont(to: alreadyLbl, isTitle: true, size: 14, fontType: .regular)
         Common.setFont(to: signInHere, isTitle: true, size: 14, fontType: .regular)
         Common.setFont(to: newPassword, isTitle: true, size: 14, fontType: .regular)
         Common.setFont(to: confirmPassword, isTitle: true, size: 14, fontType: .regular)
         Common.setFont(to: confirmPassword, isTitle: true, size: 18, fontType: .semiBold)
    }
    
   //MARK: ButtonActions.
    
    //redirectToSignIn
    @IBAction func redirectToSignIn(_ sender: UIButton) {
        let signIn = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignInViewController) as! SignInViewController
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    @IBAction func ChangePasswordUpdate(_ sender: UIButton) {
        self.userInfo = UserData()
        userInfo?.id = userId
        userInfo?.password = newPassword.text!
        userInfo?.password_confirmation = confirmPassword.text!
        self.loader.isHidden = false
        self.presenter?.post(api: .resetPassword, data: userInfo?.toData())
    }
   
    @IBAction func showNewPassword(_ sender: UIButton) {
        if sender.tag == 999 {
            newPassword.isSecureTextEntry = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "eyeoff"), for: .normal)
            sender.tag = 0
        } else {
            newPassword.isSecureTextEntry = true
            newpasswordShowBut.tag = 999
            newpasswordShowBut.setBackgroundImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }

    @IBAction func showConfirmPassword(_ sender: UIButton) {
        
        if sender.tag == 888 {
            confirmPassword.isSecureTextEntry = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "eyeoff"), for: .normal)
            sender.tag = 0
        } else {
            confirmPassword.isSecureTextEntry = true
            confirmPasswordShowBut.tag = 888
            confirmPasswordShowBut.setBackgroundImage(#imageLiteral(resourceName: "eye"), for: .normal)
        }
    }
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
    }
    
    //MARK: - Forget password id and otp
    
    func getForgetPasswordOTP(otp: Int, id: Int) {
        
        self.userId = id
        print("UserBase",userId!)
    }
    
}

// MARK: - TextField Delegate
extension ForgotPasswordController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK:  PostViewProtocol

extension ForgotPasswordController: PostViewProtocol{
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
    }
    
    func getOtp(api: Base, otp: OTP?) {
        if api == .resetPassword, let message = otp?.message {
            print(message)
            self.loader.isHidden = true
        }
    }
    
}
