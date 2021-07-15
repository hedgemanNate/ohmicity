//
//  SuggestViewController.swift
//  Ohmicity
//
//  Created by Nate Hedgeman on 5/6/21.
//

import UIKit
import Firebase
import MaterialComponents

class SuggestViewController: UIViewController {
    
    //Properties
    @IBOutlet weak var businessNameTextField: MDCFilledTextField!
    @IBOutlet weak var businessCityTextField: MDCFilledTextField!
    @IBOutlet weak var businessPhoneTextField: MDCFilledTextField!
    @IBOutlet weak var whyTextView: UITextView!
    @IBOutlet weak var sendButton: MDCButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        //Keyboard
        hideKeyboardWhenTappedAround()
        
    }
    
    
    private func updateViews() {
        //Textfields
        businessNameTextField.leadingAssistiveLabel.textColor = .white
        businessNameTextField.leadingAssistiveLabel.text = "Business Name"
        businessNameTextField.placeholder = "Business Name"
        businessNameTextField.setFilledBackgroundColor(.clear, for: .normal)
        businessNameTextField.setFilledBackgroundColor(.clear, for: .editing)
        businessNameTextField.setTextColor(cc.mainColorPurple, for: .normal)
        businessNameTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        businessNameTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        businessNameTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        businessNameTextField.tintColor = cc.mainColorPurple
        
        businessCityTextField.leadingAssistiveLabel.textColor = .white
        businessCityTextField.leadingAssistiveLabel.text = "City"
        businessCityTextField.placeholder = "City"
        businessCityTextField.setFilledBackgroundColor(.clear, for: .normal)
        businessCityTextField.setFilledBackgroundColor(.clear, for: .editing)
        businessCityTextField.setTextColor(cc.mainColorPurple, for: .normal)
        businessCityTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        businessCityTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        businessCityTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        businessCityTextField.tintColor = cc.mainColorPurple
        
        businessPhoneTextField.leadingAssistiveLabel.textColor = .white
        businessPhoneTextField.leadingAssistiveLabel.text = "Phone Number"
        businessPhoneTextField.placeholder = "555-555-5555"
        businessPhoneTextField.setFilledBackgroundColor(.clear, for: .normal)
        businessPhoneTextField.setFilledBackgroundColor(.clear, for: .editing)
        businessPhoneTextField.setTextColor(cc.mainColorPurple, for: .normal)
        businessPhoneTextField.setTextColor(cc.typingTextColorPurple, for: .editing)
        businessPhoneTextField.setUnderlineColor(cc.mainColorPurple, for: .normal)
        businessPhoneTextField.setUnderlineColor(cc.typingTextColorPurple, for: .editing)
        businessPhoneTextField.tintColor = cc.mainColorPurple
        
        //Buttons
        sendButton.layer.cornerRadius = 10
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = cc.mainColorPurple
        
        //TextView
        whyTextView.layer.cornerRadius = 10
        whyTextView.layer.backgroundColor = cc.textViewBackground.cgColor
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
