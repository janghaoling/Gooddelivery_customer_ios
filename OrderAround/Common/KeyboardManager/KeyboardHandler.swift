//
//  KeyboardHandler.swift
//  orderAround
//
//  Created by Rajes on 18/02/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit

private weak var activeTextInputView: UIView?
private var keyboardUserInfo: Notification?
private var isKeyboardPresent: Bool = false
private var viewOriginalFrameCache: CGRect?

extension UIViewController {
    
    func enableKeyboardHandling() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextFieldBeginEdit(notification:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextFieldEndEdit(notification:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextViewBeginEdit(notification:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextViewDidChange(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextViewEndEdit(notification:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    func disableKeyboardHandling() {
        //Safely remove these particular observer only don't use "remove all"
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    @objc private func onKeyboardShow(notification: Notification) {
        
        let keyboardFrame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        isKeyboardPresent = true
        keyboardUserInfo = notification
        
        if let kf = keyboardFrame, let inputView = activeTextInputView {
            //get view position based on window not on immediate parent
            // to: nil - means calcute position based on window
            let inputViewOrigin = inputView.convert(CGPoint(x: 0, y: 0) , to: nil)
            
            //Check whether UITextField / UITextView hide behind keyboard or not
            if kf.minY < inputViewOrigin.y + inputView.frame.height {
                
                //Calculte keyboard starting posiotion using 'kf.minY'
                //Calculate UITextField / UITextView starting posiotion using 'inputViewOrigin.y'
                //Calculate UITextField / UITextView height using 'inputView.frame.height'
                //Get View Already moved position using 'self.view.frame.minY'
                var movingDistance = (kf.minY - inputViewOrigin.y) - inputView.frame.height + self.view.frame.minY - 10
                
                //If movingDistance greater than keyboard height reset the movingDistance equal to keyboard height
                if abs(movingDistance) > kf.height {
                    movingDistance = -kf.height
                }
                //Capture the view original frame before move
                viewOriginalFrameCache = self.view.frame
                //Finally move the top view to particular movingDistance
                self.view.frame = CGRect(x: 0, y: movingDistance, width: self.view.frame.width, height: self.view.frame.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func onKeyboardHide(notification: Notification) {
        isKeyboardPresent = false
        keyboardUserInfo = nil
        
        //If Keyboard hide reset the view frame position to original position
        if let frame = viewOriginalFrameCache {
            self.view.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
            self.view.layoutIfNeeded()
            viewOriginalFrameCache = nil
        }
    }
    
    @objc private func onTextFieldBeginEdit(notification: Notification) {
        activeTextInputView = notification.object as? UITextField
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
    
    @objc private func onTextFieldEndEdit(notification: Notification) {
        activeTextInputView = nil
    }
    
    @objc private func onTextViewBeginEdit(notification: Notification) {
        activeTextInputView = notification.object as? UITextView
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
    
    @objc private func onTextViewDidChange(notification: Notification) {
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
    
    @objc private func onTextViewEndEdit(notification: Notification) {
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
}

