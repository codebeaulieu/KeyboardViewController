//
//  KeyboardViewController.swift
//  KeyboardViewController
//
//  Created by Dan Beaulieu on 9/3/16.
//  Copyright © 2016 Dan Beaulieu. All rights reserved.
//

import UIKit

class KeyboardViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    override func viewDidLoad() {
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
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
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height {
            view.frame.origin.y += (keyboardHeight - 30)
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size,
            let offset = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            if keyboardSize.height == offset.height {
                if self.view.frame.origin.y == 0 {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.view.frame.origin.y -= (keyboardSize.height - 30)
                    })
                }
            } else {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y += (keyboardSize.height - 30) - offset.height
                })
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

