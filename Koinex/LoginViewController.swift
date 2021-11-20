//
//  LoginViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 10/10/21.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {
    @IBOutlet weak var txtfield_username: UITextField!
    @IBOutlet weak var txtfield_password: UITextField!
    
    var email:String = ""
    var password:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.navigationItem.title = "Logout"
        self.navigationItem.backButtonTitle = "Logout"
        

        // Do any additional setup after loading the view.
    }
    @IBAction func signInBtnClicked(_ sender: Any) {
       // navigateToHomeScreen()
        
       
        email = txtfield_username.text ?? ""
        password = txtfield_password.text ?? ""
        
        
        if ((email != "") && (password != "")) {
            
            if(Validation.isValidEmail(email)) {
                // Call Login Service
                loginService()
            } else {
                // Please Enter Valid Username & Password
                
                Alert.showBasicAlert(vc: self, title: "Error!", msg: "Incorrect username or password")
            }
        } else {
            Alert.showBasicAlert(vc: self, title: "Error!", msg: "Incorrect username or password")
        }
        
     
        
        
    }
    @IBAction func btn_forgotPassClicked(_ sender: Any) {
        
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Reset Password", message: "Please Enter Email", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Please Enter Email"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Reset", style: .default) { _ in

            // this code runs when the user hits the "save" button

            let email = alertController.textFields![0].text

            print(email ?? "")
            
            Auth.auth().sendPasswordReset(withEmail: email ?? "") { error in
              // ...
                if error != nil {
                    print("Error sending reset password email")
                    Alert.showBasicAlert(vc: self, title: "Error!", msg: "Please Enter Valid Email Address")
                } else {
                    print("Reset Password email sent successfully")
                    Alert.showBasicAlert(vc: self, title: "Success!", msg: "Reset Password Email Sent Successfully")
                }
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func loginService() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
          
            if error != nil {
                print("Incorrect Username or Password")
                Alert.showBasicAlert(vc: self, title: "Error!", msg: "Incorrect username or password")
            } else {
                // Login Succesfuly
                let emailVerified: Bool = result?.user.isEmailVerified ?? false
                if (emailVerified) {
                UID = result?.user.uid ?? ""
                print ("UID = ", UID)
                self.navigateToHomeScreen()
                    
                } else {
                    Alert.showBasicAlert(vc: self, title: "Error!", msg: "Please Verify Email")
                }
              
            }
        }
    }
    
    func navigateToHomeScreen() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as! UITabBarController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
   
 

}
