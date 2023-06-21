//
//  EditProfileViewController.swift
//  Project
//
//  Created by CSS on 17/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelMail: UILabel!
    @IBOutlet weak var labelMobile: UILabel!
    
    @IBOutlet weak var fieldMail: UITextField!
    @IBOutlet weak var fieldMobile: UITextField!
    @IBOutlet weak var fieldUserName: UITextField!
    
    @IBOutlet weak var buttonUpdate: UIButton!
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    var editUserDetails:UserProfileDetails!
    var isUpdated:Bool = false //local flag for check user profile updated or not
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboardHandling()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageProfile.makeRoundedCorner()
    }

}

extension EditProfileViewController {
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    @IBAction func backToPreviousScreen(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapUpdate(_ sender: UIButton) {
        guard let userName = self.fieldUserName.text, userName.count > 0 else {
            Common.showToast(string: ErrorMessage.list.enterUserName.localize())
            return
        }
        
        guard let email = self.fieldMail.text, email.count > 0 else {
            Common.showToast(string: ErrorMessage.list.enterEmail.localize())
            return
        }
        
        guard Common.isValid(email: email) else {
            Common.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            return
        }
        
        editUserDetails.name = userName
//        editUserDetails.phone = mobileNumber
        editUserDetails.email = email
        updateUserProfile(userDetails: editUserDetails)
    }
    
    private func initialLoads() {
        
        Common.setFont(to: labelMobile, isTitle: false, size: 14, fontType: .light)
        Common.setFont(to: labelUserName, isTitle: false, size: 14, fontType: .light)
        Common.setFont(to: labelMail, isTitle: false, size: 14, fontType: .light)
        Common.setFont(to: fieldMobile, isTitle: false, size: 17, fontType: .semiBold)
        Common.setFont(to: fieldUserName, isTitle: false, size: 17, fontType: .semiBold)
        Common.setFont(to: fieldMail, isTitle: false, size: 17, fontType: .semiBold)
        Common.setFont(to: labelTitle)
        self.fieldMobile.isUserInteractionEnabled = false
        self.buttonUpdate.addTarget(self, action: #selector(tapUpdate(_:)), for: .touchUpInside)
        localize()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapProfileImage))
        self.imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(gesture)
        
        getUserProfileDetails()
    }
    
    private func localize() {
        self.labelTitle.text = APPLocalize.localizestring.editAccount.localize().uppercased()
        self.labelMail.text = APPLocalize.localizestring.emailAddress.localize().uppercased()
        self.labelUserName.text = APPLocalize.localizestring.userName.localize().uppercased()
        self.labelMobile.text = APPLocalize.localizestring.MobileNumber.localize().uppercased()
        self.buttonUpdate.setTitle(APPLocalize.localizestring.update.localize().uppercased(), for: .normal)
    }
    
    @objc func tapProfileImage() {
        self.showImage { (selectedImage) in
            self.imageProfile.image = selectedImage
        }
    }
    
    func setUserDetailsonView(userDetails:UserProfileDetails) {
        self.fieldUserName.text = userDetails.name ?? ""
        self.fieldMobile.text = userDetails.phone ?? ""
        self.fieldMail.text = userDetails.email ?? ""
        self.imageProfile.setImage(with:userDetails.avatar ?? "", placeHolder: #imageLiteral(resourceName: "userPlaceholder"))
        self.fieldMail.delegate = self
        self.fieldMobile.delegate = self
        self.fieldUserName.delegate = self
    }
}



extension EditProfileViewController: PostViewProtocol {
       
    func onError(api: Base, message: String, statusCode code: Int) {
        self.loader.isHidden = true
        Common.showToast(string: message)
    }
    
    func getUserProfileDetails() {
        
        if User.main.accessToken != nil {
            loader.isHidden = false
            self.presenter?.get(api: .userProfile, data: nil)
        }
    }
    
    func getUserProfile(api: Base, data: UserProfileDetails?) {
        
        if api == .userProfile, data != nil {
            DispatchQueue.main.async {
                if self.isUpdated {
                    Common.showToast(string: APPLocalize.localizestring.profileUpdated.localize())
                    self.navigationController?.popViewController(animated: true)
                    self.isUpdated = false
                }
                self.loader.isHideInMainThread(true)
                Common.storeUserData(from: data)
                self.editUserDetails = data
                self.setUserDetailsonView(userDetails: data ?? UserProfileDetails())
            }
        }
    }
    
    func updateUserProfile(userDetails:UserProfileDetails) {
        if User.main.accessToken != nil {
            var uploadimgeData:Data!
            
            if  let dataImg = UIImageJPEGRepresentation(imageProfile.image ?? UIImage(), 0.4) {
                uploadimgeData = dataImg
            }
            isUpdated = true
            let imageName = Constants.string.uploadFileName
            self.loader.isHideInMainThread(false)
            self.presenter?.post(api: .userProfile, imageData: [imageName:uploadimgeData], data: userDetails.toData())
        }
    }
    
}

extension EditProfileViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
