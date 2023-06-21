//
//  Global.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Foundation
import PopupDialog
import AudioToolbox

var currentBundle : Bundle!
var selectedLanguage : Language = .spanish

//MARK:- Show Alert
internal func showAlert(message : String?, handler : ((UIAlertAction) -> Void)? = nil)->UIAlertController{
    
    let alert = UIAlertController(title: AppName, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:  APPLocalize.localizestring.OK, style: .default, handler: handler))
    alert.view.tintColor = .primary
    return alert
}


//MARK:- Show Alert With Action

func showAlert(message : String?, okHandler : (()->Void)?, fromView : UIViewController){
    
    /* let alert = UIAlertController(title: AppName,
     message: message,
     preferredStyle: .alert)
     let okAction = UIAlertAction(title: Constants.string.OK, style: .default, handler: okHandler)
     
     let cancelAction = UIAlertAction(title: Constants.string.Cancel, style: .destructive, handler: nil)
     
     alert.addAction(okAction)
     alert.addAction(cancelAction)
     alert.view.tintColor = .primary */
    
    let alert = PopupDialog(title: message, message: nil)
    let okButton =  PopupDialogButton(title: APPLocalize.localizestring.yes.localize(), action: {
        okHandler?()
        alert.dismiss()
    })
    let cancelButton = PopupDialogButton(title: APPLocalize.localizestring.no.localize()) {
        alert.dismiss()
    }
    alert.transitionStyle = .zoomIn
    alert.addButton(okButton)
    alert.addButton(cancelButton)
    fromView.present(alert, animated: true, completion: nil)
    
}



//MARK:- ShowLoader

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.primary.cgColor
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.activityIndicatorViewStyle = .whiteLarge
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    uiView.addSubview(container)
    actInd.startAnimating()
    
    return container
    
}

internal func saveFilterDetails(data: [String:[FilterItems]]) {
    
    let itemList = data.map({$0.value}).flatMap({$0})
    UserDefaults.standard.set(try? PropertyListEncoder().encode(itemList), forKey: Keys.list.filterDetails)
    UserDefaults.standard.synchronize()
}

internal func getFilterDetails() -> [String:[FilterItems]] {
    if let data = UserDefaults.standard.object(forKey: Keys.list.filterDetails) as? Data,let filterData =  try? PropertyListDecoder().decode([FilterItems].self, from: data)  {
        let filterDictionary = Dictionary(grouping: filterData, by: {$0.type})
        return filterDictionary
    }
    
    return [String:[FilterItems]]()
}

internal func isAppliedFilter() -> Bool{
    for filter in getFilterDetails() {
        let filterd = filter.value.filter({$0.state == true})
        if filterd.count > 0 {
            return true
        }
    }
    return false
}

internal func removeFilterDetails() {
    
    UserDefaults.standard.removeObject(forKey: Keys.list.filterDetails)
}


internal func storeInUserDefaults(){
    
    let data = NSKeyedArchiver.archivedData(withRootObject: User.main)
    UserDefaults.standard.set(data, forKey: Keys.list.userData)
    UserDefaults.standard.synchronize()
    
    print("Store in UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Failed")
}

// Retrieve from UserDefaults
internal func retrieveUserData()->Bool{

    if let data = UserDefaults.standard.object(forKey: Keys.list.userData) as? Data, let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
        
        User.main = userData
        
        return true
    }
    
    return false
    
}

// Clear UserDefaults
internal func clearUserDefaults(){
    
    User.main = initializeUserData()  // Clear local User Data
    UserDefaults.standard.set(nil, forKey: Keys.list.userData)
    UserDefaults.standard.removeVolatileDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    
    setLocalization(language: .english)
    selectedLanguage = .english
    
    
    UserDefaults.standard.set(selectedLanguage.rawValue, forKey: Keys.list.language)
    print("Clear UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Success")
    
}

func toastSuccess(_ view:UIView,message:NSString,smallFont:Bool,isPhoneX:Bool, color:UIColor){
    var labelView = UIView()
    if(isPhoneX){
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 60))
    }else{
        labelView = UILabel(frame: CGRect(x: 0,y: 0,width:view.frame.size.width, height: 60))
    }
    labelView.backgroundColor = color
    
    //UIColor(red: 35/255, green: 86/255, blue: 142/255, alpha: 1)
    
    
    let  toastLabel = UILabel(frame: CGRect(x: 0,y:(labelView.frame.size.height/2)-20,width:view.frame.size.width, height: labelView.frame.size.height/2))
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = NSTextAlignment.center
    toastLabel.numberOfLines = 2
    if(smallFont){
        // toastLabel.font = UIFont.boldSystemFont(ofSize: 10)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
    }else{
        // toastLabel.font = toastLabel.font.withSize(14)
        toastLabel.font = UIFont(name: "Avenir Next Medium", size: 18)
    }
    
    labelView.addSubview(toastLabel)
    view.addSubview(labelView)
    toastLabel.text = message as String
    labelView.alpha = 1.0
    let deadlineTime = DispatchTime.now() + .seconds(2)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        labelView.alpha = 0.0
        labelView.removeFromSuperview()
    }
}


internal func forceLogout(with message : String? = nil) {
    
    clearUserDefaults()

    UIApplication.shared.windows.last?.rootViewController?.popOrDismiss(animation: true)
    let navigationVC = UINavigationController(rootViewController: Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SignSkipViewController))
    navigationVC.navigationBar.isHidden = true
    UIApplication.shared.windows.first?.rootViewController = navigationVC
    UIApplication.shared.windows.first?.makeKeyAndVisible()
    
    
    
   if message != nil {
        UIApplication.shared.windows.last?.rootViewController?.view.makeToast(message, duration: 2, position: .center, title: nil, image: nil, style: ToastStyle(), completion: nil)
    }

    
 
    
}

// Initialize User

internal func initializeUserData()->User
{
    return User()
}


func setLocalization(language : Language){
    
    if let path = Bundle.main.path(forResource: language.code, ofType: "lproj"), let bundle = Bundle(path: path) {
        let attribute : UISemanticContentAttribute = language == .arabic ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        selectedLanguage = language
        currentBundle = bundle
    } else {
        currentBundle = .main
    }
    
}


func vibrate(sound: defaultSystemSound) {
    AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(sound.rawValue)) {
        // do what you'd like now that the sound has completed playing
    }
 }








