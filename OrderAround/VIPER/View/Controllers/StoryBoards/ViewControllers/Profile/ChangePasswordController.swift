//
//  ConfirmPasswordViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//



import UIKit

class ChangePasswordController: UIViewController {
    
    @IBOutlet weak var fieldOldPassword: UITextField!
    @IBOutlet weak var fieldNewPassword: UITextField!
    @IBOutlet weak var fieldConfirmPassword: UITextField!
    
    @IBOutlet weak var buttonNewPassword: UIButton!
    @IBOutlet weak var buttonOldPassword: UIButton!
    @IBOutlet weak var buttonConfirmPassword: UIButton!
    @IBOutlet weak var buttonChangePassword: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
   
    private var userInfo: UserData?
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    var userId: Int?
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        hideKeyboardWhenTappedAround()
        self.buttonOldPassword .setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        self.buttonNewPassword .setImage(#imageLiteral(resourceName: "eye"), for: .normal)
        self.buttonConfirmPassword .setImage(#imageLiteral(resourceName: "eye"), for: .normal)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableKeyboardHandling()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    
    //MARK: ButtonActions.
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapChangePassword(_ sender: UIButton) {
        guard let oldPassword = fieldOldPassword.text, !oldPassword.isEmpty else {
            Common.showToast(string: ErrorMessage.list.enterOldPassword.localize())
            return
        }
        guard let newPassword = fieldNewPassword.text, !newPassword.isEmpty  else {
            Common.showToast(string: ErrorMessage.list.enterNewPwd.localize())
            return
        }
        guard let confirmPassword = fieldConfirmPassword.text, !confirmPassword.isEmpty else {
            Common.showToast(string: ErrorMessage.list.enterConfirmPwd.localize())
            return
        }
        guard oldPassword.count >= 6 || newPassword.count  >= 6 || confirmPassword.count >= 6 else {
            Common.showToast(string: ErrorMessage.list.passwordLength.localize())
            return
        }
        guard newPassword == confirmPassword else {
            Common.showToast(string: ErrorMessage.list.passwordDonotMatch.localize())
            return
        }
        var changePassword = ChangePassword()
        changePassword.password_old = oldPassword
        changePassword.password = newPassword
        changePassword.password_confirmation = confirmPassword
        self.loader.isHidden = false
        self.presenter?.post(api: .changePassword, data: changePassword.toData())
    }
    
    @IBAction func tapPasswordButton(_ sender:UIButton) {
        if sender.tag == 1 {
            self.fieldOldPassword.isSecureTextEntry = !self.fieldOldPassword.isSecureTextEntry
            let image = UIImage(named: fieldOldPassword.isSecureTextEntry ? "eye" : "eyeoff")
            self.buttonOldPassword .setImage(image, for: .normal)
        }else if sender.tag == 2  {
            self.fieldNewPassword.isSecureTextEntry = !self.fieldNewPassword.isSecureTextEntry
            let image = UIImage(named: fieldNewPassword.isSecureTextEntry ? "eye" : "eyeoff")
            self.buttonNewPassword .setImage(image, for: .normal)
        }else if sender.tag == 3  {
            self.fieldConfirmPassword.isSecureTextEntry = !self.fieldConfirmPassword.isSecureTextEntry
            let image = UIImage(named: fieldConfirmPassword.isSecureTextEntry ? "eye" : "eyeoff")
            self.buttonConfirmPassword .setImage(image, for: .normal)
        }
    }
    
}

//MARK: - Methods
extension ChangePasswordController  {
    private func initialLoads()  {
        self.buttonNewPassword.addTarget(self, action: #selector(tapPasswordButton(_:)), for: .touchUpInside)
        self.buttonOldPassword.addTarget(self, action: #selector(tapPasswordButton(_:)), for: .touchUpInside)
        self.buttonConfirmPassword.addTarget(self, action: #selector(tapPasswordButton(_:)), for: .touchUpInside)
        self.buttonChangePassword.addTarget(self, action: #selector(tapChangePassword(_:)), for: .touchUpInside)
        self.buttonOldPassword.tag = 1
        self.buttonNewPassword.tag = 2
        self.buttonConfirmPassword.tag = 3
        self.buttonChangePassword.backgroundColor = .secondary
        localize()
        setFont()
    }
    private func localize() {
        self.fieldConfirmPassword.placeholder = APPLocalize.localizestring.confirmPassword.localize()
        self.fieldNewPassword.placeholder = APPLocalize.localizestring.newPassword.localize()
        self.fieldOldPassword.placeholder = APPLocalize.localizestring.oldPassword.localize()
        self.buttonChangePassword.setTitle(APPLocalize.localizestring.change.localize(), for: .normal)
        self.labelTitle.text = APPLocalize.localizestring.changePassword.localize()
    }
    private func setFont() {
        Common.setFont(to: fieldConfirmPassword)
        Common.setFont(to: fieldNewPassword)
        Common.setFont(to: fieldOldPassword)
        Common.setFont(to: buttonChangePassword)
        Common.setFont(to: labelTitle)
    }
}

// MARK: - TextField Delegate
extension ChangePasswordController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK:  PostViewProtocol

extension ChangePasswordController: PostViewProtocol {
    
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
            Common.showToast(string: message)
        }
    }
    
    func getChangePassword(api: Base, data: Message?) {
        let alert = showAlert(message: APPLocalize.localizestring.passwordChanged.localize()) { (_) in
            clearUserDefaults()
            forceLogout()
        }
        self.loader.isHideInMainThread(true)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
