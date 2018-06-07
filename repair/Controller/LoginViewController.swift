//
//  LoginViewController.swift
//  repair
//
//  Created by Ahmad Karkouty on 6/1/18.
//  Copyright © 2018 Ahmad Karkouti. All rights reserved.
//

import UIKit
import FoldingTabBar
import CountryPickerView
import TextFieldEffects
import Firebase
import FirebaseAuth
import SVProgressHUD
import SDOtpField


class LoginViewController: UIViewController {
    let textField = HoshiTextField(frame: CGRect(x:170, y: 395, width: 160, height: 50))
    let firstNameField = MadokaTextField(frame: CGRect(x:170, y: 325, width: 160, height: 50))
    let lastNameField = MadokaTextField(frame: CGRect(x:170, y: 395, width: 160, height: 50))
    @IBOutlet weak var otpField: SDOtpField!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var cpvMain: CountryPickerView!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var verifyLabel2: UILabel!
    
    @IBOutlet weak var finalButton: UIButton!
    @IBOutlet weak var tryText: UITextField!
    override func viewDidLoad() {
        
        
        
        
        
        super.viewDidLoad()
        firstView.isHidden = false
        secondView.isHidden = true
        thirdView.isHidden = true
        
        cpvMain.tag = 1
        cpvMain.dataSource = self
        otpField.numberOfDigits = 6
        otpField.reloadFields()
        textField.placeholderColor = .darkGray
        textField.borderInactiveColor = .black
        textField.borderActiveColor = .blue
        textField.keyboardType = UIKeyboardType.numberPad
        secondView.addSubview(textField)
        textField.showDoneButtonOnKeyboard()
        
        firstNameField.placeholderColor = .green
        firstNameField.layer.cornerRadius = 10
        firstNameField.borderColor = .red
        firstNameField.placeholder = "First Name:"
        firstNameField.textColor = .white
        thirdView.addSubview(firstNameField)
        firstNameField.showDoneButtonOnKeyboard()
        
        lastNameField.textColor = .white
        lastNameField.placeholderColor = .green
        lastNameField.layer.cornerRadius = 10
        lastNameField.borderColor = .red
        lastNameField.placeholder = "Last Name:"
        thirdView.addSubview(lastNameField)
        lastNameField.showDoneButtonOnKeyboard()
        
//        textField2.placeholderColor = .darkGray
//        textField2.borderInactiveColor = .black
//        textField2.borderActiveColor = .blue
//        textField2.keyboardType = UIKeyboardType.numberPad
//        thirdView.addSubview(textField2)
//        textField2.showDoneButtonOnKeyboard()
    


        }
    

//        navigationController?.popViewController(animated: true)

    
    @IBAction func hereBtn(_ sender: Any) {
        firstView.isHidden = false
        thirdView.isHidden = true
        secondView.isHidden = true
    }
    
    
    @IBAction func finalSubmit(_ sender: Any) {
        
        
        
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: otpField.currentOtp)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "error: \(String(describing: error!.localizedDescription))")
                SVProgressHUD.dismiss(withDelay: 2.5)
            } else {
                print("Phone Number: \(String(describing: user?.phoneNumber))")
                let userInfo = user?.providerData[0]
                print("Provider Data: \(String(describing: userInfo?.providerID))")
                if Auth.auth().currentUser != nil {
                    
                    guard let uid = user?.uid else {
                        return
                    }
                    let First = self.firstNameField.text!
                    let Last = self.lastNameField.text!
                    let country = self.cpvMain.selectedCountry
                    let myNumber = "\(country.phoneCode)\(self.textField.text!)"
                    
                    
                    let ref = Database.database().reference()
                    let userReference = ref.child("users").child(uid)
                    let values = ["id": uid, "FirstName": First, "LastName": Last, "Number": myNumber]
                    userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err ?? "")
                            return
                        }
                        print("Saved User Successfully Into Firebase db")
                    })
                    
                    
                    
                    
                    
                    
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                }
                
                
            }
        }
    }
    
    
    

    @IBAction func submitButton(_ sender: Any) {
        let country = cpvMain.selectedCountry
        let myNumber = "\(country.phoneCode)\(textField.text!)"
        verifyLabel.text = "Verify \(myNumber)"
        verifyLabel2.text = "Didn't receive a code at \(myNumber)? \nChange Number"
        let alert = UIAlertController(title: "Phone Number", message: "Is this your phone number? \(myNumber)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            PhoneAuthProvider.provider().verifyPhoneNumber(myNumber, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                    SVProgressHUD.dismiss()
                    SVProgressHUD.showSuccess(withStatus: "error: \(String(describing: error!.localizedDescription))")
                    SVProgressHUD.dismiss(withDelay: 2.5)
                } else {
                    let defaults = UserDefaults.standard
                    defaults.set(verificationID, forKey: "authVID")
                    self.firstView.isHidden = true
                    self.secondView.isHidden = true
                    self.thirdView.isHidden = false
                    
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
            }
            
            
        }
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        firstView.isHidden = true
        secondView.isHidden = false
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }


}


extension LoginViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        showAlert(title: title, message: message)
    }
}

extension LoginViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if countryPickerView.tag == cpvMain.tag {
            var countries = [Country]()
            ["LB"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code) {
                    countries.append(country)
                }
            }
            return countries
        }
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == cpvMain.tag {
            return "Preferred title"
        }
        return nil
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
    
    extension UITextField {
        func showDoneButtonOnKeyboard() {
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
            
            var toolBarItems = [UIBarButtonItem]()
            toolBarItems.append(flexSpace)
            toolBarItems.append(doneButton)
            
            let doneToolbar = UIToolbar()
            doneToolbar.items = toolBarItems
            doneToolbar.sizeToFit()
            
            inputAccessoryView = doneToolbar
        }
    }

    
    
    

    
