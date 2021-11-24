//
//  RegistrationViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 10/10/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: UIViewController {

    @IBOutlet weak var txtfield_firstName: UITextField!
    @IBOutlet weak var txtfield_lastName: UITextField!
    @IBOutlet weak var txtfield_mobileNo: UITextField!
    @IBOutlet weak var txtfield_username: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
    
    @IBOutlet weak var lbl_firstnameErr: UILabel!
    @IBOutlet weak var lbl_lastnameErr: UILabel!
    @IBOutlet weak var lbl_mobilenoErr: UILabel!
    @IBOutlet weak var lbl_emailErr: UILabel!
    @IBOutlet weak var lbl_passwordErr: UILabel!
    var firstName:String = ""
    var lastName:String = ""
    var mobileNo:String = ""
    var email:String = ""
    var password:String = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func registerBtnClicked(_ sender: Any) {
        
      checkforValidations()
        
        if (lbl_lastnameErr.isHidden && lbl_firstnameErr.isHidden && lbl_mobilenoErr.isHidden && lbl_emailErr.isHidden && lbl_passwordErr.isHidden) {
            
            registerUser()
        } else {
            Alert.showBasicAlert(vc: self, title: "Error!", msg: "One or more fields incorrect.")
        }
      
    }
    
    func checkforValidations() {
        
        lbl_firstnameErr.isHidden = true
        lbl_lastnameErr.isHidden = true
        lbl_mobilenoErr.isHidden = true
        lbl_emailErr.isHidden = true
        lbl_passwordErr.isHidden = true
        
        firstName = txtfield_firstName.text ?? ""
        lastName = txtfield_lastName.text ?? ""
        mobileNo = txtfield_mobileNo.text ?? ""
        email = txtfield_username.text ?? ""
        password = txtfield_password.text ?? ""
        
   
        if (!Validation.containsOnlyLetters(input: firstName) || firstName == "" ) {
            lbl_firstnameErr.isHidden = false
        }
        if (!Validation.containsOnlyLetters(input: lastName) || lastName == "") {
            lbl_lastnameErr.isHidden = false
        }
        if (!Validation.isValidPhone(phone: mobileNo)) {
            lbl_mobilenoErr.isHidden = false
        }
        
        if (!Validation.isValidEmail(email)) {
                lbl_emailErr.isHidden = false
        }
            
        if (!Validation.isPasswordValid(password: password)) {
            lbl_passwordErr.isHidden = false
        }
        
    }

    
    func registerUser() {
        // Creating-Registering New Users
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            // Check for errors
            if error != nil {
                print("Error Creating User")
                Alert.showBasicAlert(vc: self, title: "Error Creating User!", msg: "Oops Some Unexpected Error Occured, please try after some time!")
            } else {
                // User Created Succesfully, store info about users
                self.db.collection("users").document(authResult!.user.uid).setData(["firstname": firstName, "lastname":lastName, "mobileno":mobileNo, "uid": authResult!.user.uid, "Portfolio": ["ADA": 0, "BTC": 0, "DOGE": 0, "ETH": 0, "XRP": 0],"Wallet": ["cashback": 0, "totalfunds": 0]]) { (err) in
                    
                    if err != nil {
                        print("Error Assigning Info About User")
                        Alert.showBasicAlert(vc: self, title: "Error!", msg: "Oops Some Unexpected Error Occured, please try after some time!")
                    }
                    
                    
                }
                
                authResult?.user.sendEmailVerification { error in
                    if error != nil {
                        print(error!)
                        print("Error Assigning Info About User")
                        Alert.showBasicAlert(vc: self, title: "Error!", msg: "Oops Some Unexpected Error Occured, please try after some time!")
                    } else {
                        // User Created Sucessfully
                    // Registration Succesfull Popup & Redirect to Sign In Page
                    print("User Added Succesfully")
                    //self.dismiss(animated: true, completion: nil)
                    showSucessAlert()
                    }
                }
              
              
            }
        }
    }
    
  

    func showSucessAlert() {
        
        let loginAlert = UIAlertController(title: "Success!", message: "Registration Succesful.", preferredStyle: UIAlertController.Style.alert)

        loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              //print("Handle Ok logic here")
              self.dismiss(animated: true, completion: nil)
        }))

        present(loginAlert, animated: true, completion: nil)
    }
}
