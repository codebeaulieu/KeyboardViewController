//
//  KeyboardViewController.swift
//  KeyboardViewController
//
//  Created by Dan Beaulieu on 9/3/16.
//  Copyright © 2016 Dan Beaulieu. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        
        
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(_:)))
        tap.delegate = self
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
    }
    
    func backgroundTap(_ sender: UITapGestureRecognizer? = nil) {
        dismissKeyboard()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: view.window)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: view.window)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: view.window)
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        view.frame.origin.y += distanceMoved
        
    }
    
    var distanceMoved : CGFloat!
    
    func keyboardWillShow(_ notification: Notification) {
        guard let activeField = self.activeField else { assertionFailure("this should never fail"); return }
        let absoluteframe: CGRect = (activeField.convert(activeField.frame, to: UIApplication.shared.keyWindow))
        
        print(absoluteframe.origin.y)
        
        if let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            
            if self.view.frame.origin.y == 0 {
                distanceMoved = (absoluteframe.origin.y - aRect.size.height)
                if (absoluteframe.origin.y > aRect.size.height){
                    UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                        self!.view.frame.origin.y -= self!.distanceMoved
                    })
                }
            } else {
                
                //                if (absoluteframe.origin.y > aRect.size.height){
                //
                //                    UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                //                        self!.view.frame.origin.y -= 20//((absoluteframe.origin.y - aRect.size.height) + self!.distanceMoved)
                //                    })
                //                }
            }
            
        }
    }
    
    func setDelegates(_ fields: AnyObject...) {
        for item in fields {
            if let textField = item as? UITextField {
                textField.delegate = self
            }
            if let textView = item as? UITextView {
                textView.delegate = self
            }
        }
    }
    
    func dismissKeyboard () {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObservers()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}


