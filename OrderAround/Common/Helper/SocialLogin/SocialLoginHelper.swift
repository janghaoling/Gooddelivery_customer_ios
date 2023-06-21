//
//  SocialLoginHelper.swift
//  Project
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 css. All rights reserved.
//

import Foundation


protocol SocialLoginHelperDelegate {
    
    /**
     This delegate will be called when facebook login success.
     - parameter detail: Facebook user detail will be passed as details.
     */
  //  func didReceiveFacebookLoginUser (detail: FacebookUserDetail)
    
    /**
     This delegate will be called when google login success.
     - parameter detail: Google user detail will be passed as details.
     */
    func didReceiveGoogleLoginUser (detail: GIDGoogleUser)
    
    /**
     This delegate will be called when facebook login fails with error.
     - parameter message: Facebook login failed error message.
     */
    func didReceiveFacebookLoginError (message: String)
    
    /**
     This delegate will be called when google login fails with error.
     - parameter message: Google
     login failed error message.
     */
    func didReceiveGoogleLoginError (message: String)
}

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class SocialLoginHelper: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    // MARK: - Declarations
    
    fileprivate var delegate: SocialLoginHelperDelegate!
    fileprivate var mainViewController: UIViewController!
    
    // MARK: - Facebook login methods
    
    /**
     To login through facebook authentication.
     - parameter fromViewController: Viewcontroller from which needs to be handled.
     - parameter helperDelegate: SocialLoginHelperDelegate to handle success or failure in view controller.
     */
    func loginThroughFacebook (fromViewController: UIViewController, helperDelegate: SocialLoginHelperDelegate) {
        
        var userDetail: [String: AnyObject] = [:]
        delegate = helperDelegate
        mainViewController = fromViewController
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: fromViewController) { (result, error) in
            if (error == nil){
                fbLoginManager.logOut()
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        print(FBSDKAccessToken.current())
                        if(FBSDKAccessToken.current() != nil){
                             UserDefaults.standard.set(FBSDKAccessToken.current().tokenString, forKey: Keys.list.socialLoginAccessToken)
                           
                            print("ACCESS TOKEN FOR FB: \(FBSDKAccessToken.current().tokenString)")
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name,email,first_name, last_name, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    userDetail = result as! [String : AnyObject]
                                    
                                    let facebookUserDetail = FacebookUserDetail(dictionary: userDetail)
                                  //  self.delegate.didReceiveFacebookLoginUser(detail: facebookUserDetail)
                                }
                                else { //Couldn't able to fetch final result of login details
                                    self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbGeneralError)
                                }
                            })
                        }
                        else { //Access token is empty
                            self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbNoToken)
                        }
                    }
                    else { //Doesn't contain email after getting permission
                        self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbNoEmail)
                    }
                }
                else { //Permission not granted for facebook login access
                    self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbPermissionDenied)
                }
            }
            else { //Couldn't able to get read permission for email or public_profile
                self.delegate.didReceiveFacebookLoginError(message: ERROR_MESSAGE.fbDeniedEmailAccess)
            }
        }
    }
    
    
    // MARK: - Google Login Methods
    
    /**
     To login through google authentication.
     - parameter fromViewController: Viewcontroller from which needs to be handled.
     - parameter helperDelegate: SocialLoginHelperDelegate to handle success or failure in view controller.
     */
    func loginThroughGoogle (fromViewController: UIViewController, helperDelegate: SocialLoginHelperDelegate) {
        delegate = helperDelegate
        mainViewController = fromViewController
        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn?.signOut()
        googleSignIn?.clientID = googleClientId
        googleSignIn?.serverClientID = googleserverClientId
        //"773723147149-6pflhr0585nnrrpfuv9e43gqb22vukqb.apps.googleusercontent.com"
        googleSignIn?.delegate = self
        googleSignIn?.uiDelegate = self
        googleSignIn?.shouldFetchBasicProfile = true
        googleSignIn?.signIn()
    }
    
    // MARK: - Google login delegate methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        // Perform any operations on signed in user here. Fot internal reference following code has been commented
        /*let userId = user.userID                  // For client-side use only!
         let idToken = user.authentication.idToken // Safe to send to the server
         let fullName = user.profile.name
         let givenName = user.profile.givenName
         let familyName = user.profile.familyName
         let email = user.profile.email*/
        
        if error == nil {
        
            print("ACCESS TOKEN FOR GOOGLE: \(String(describing: user.authentication.idToken))")
            UserDefaults.standard.set(user.authentication.accessToken, forKey: Keys.list.socialLoginAccessToken)
            delegate.didReceiveGoogleLoginUser(detail: user)
        }
        else {
            delegate.didReceiveGoogleLoginError(message: error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        // It call when user cancel the login entry alert need to be shown
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        mainViewController.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        mainViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Facebook user detail entity

class FacebookUserDetail {
    
    // MARK: - Declarations
    
    var userName = ""
    var name = ""
    var email = ""
    var userId = ""
    var userImage = ""
    var firstName = ""
    var lastName = ""
    
    init (dictionary: [String: AnyObject]) {
        
        userName = getValueFrom(dictionary: dictionary, key: "username") as! String
        name = getValueFrom(dictionary: dictionary, key: "name") as! String
        email = getValueFrom(dictionary: dictionary, key: "email") as! String
        userId = getValueFrom(dictionary: dictionary, key: "id") as! String
        firstName = getValueFrom(dictionary: dictionary, key: "first_name") as! String
        lastName = getValueFrom(dictionary: dictionary, key: "last_name") as! String
        
        if let imageURL = ((dictionary["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
            userImage = imageURL
        }
        
    }
}


public func getValueFrom( dictionary: Any, key:String) -> Any {
    
    if dictionary is [String:Any] , let val = (dictionary as! [String:Any])[key]{
        
        return val as Any
        
        
    } else {
        return "" as Any
    }
}
