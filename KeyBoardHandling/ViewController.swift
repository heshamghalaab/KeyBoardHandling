//
//  ViewController.swift
//  KeyBoardHandling
//
//  Created by hesham ghalaab on 6/4/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet private var textFields: [UITextField]!
    
    // MARK: Properties
    private var activeField: UITextField?

    // MARK: Override Functions
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        addKeyboardObservers()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: Methods
    /// to configure any protocols
    private func configuration(){
        textFields.forEach { $0.delegate = self }
    }
    
    /// Called to register For Keyboard Notifications
    private func addKeyboardObservers(){
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWasShown(_:)),
                           name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillBeHidden(_:)),
                           name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Called to remove observers on keyboard
    private func removeKeyboardObservers(){
        let center = NotificationCenter.default
        center.removeObserver(self,
                              name: UIResponder.keyboardWillShowNotification,
                              object: nil)
        center.removeObserver(self,
                              name: UIResponder.keyboardWillHideNotification,
                              object: nil)
    }
    
    /// Called when the UIKeyboardDidShowNotification is sent.
    @objc private func keyboardWasShown(_ notification: NSNotification){
        guard let aKeyboard = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {return}
        let aKeyboardSize = aKeyboard.cgRectValue
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: aKeyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        guard let activeField = activeField else { return }
        var aRect = self.view.frame
        aRect.size.height -= aKeyboardSize.height
        
        guard (!aRect.contains(activeField.frame.origin) ) else { return }
        self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
    }
    
    /// Called when the UIKeyboardWillHideNotification is sent
    @objc private func keyboardWillBeHidden(_ notification: NSNotification){
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}

