//
//  WalletViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 10/21/21.
//

import UIKit
import FirebaseFirestore

class WalletViewController: UIViewController {
    @IBOutlet weak var txrtlbl_AvailableFunds: UILabel!
    var availableFunds: Double = 0.0
    let db = Firestore.firestore()
    let dispatchGroup = DispatchGroup()
    let semaphore = DispatchSemaphore(value:0)
    //let walletRef = db.collection("users").document(UID)
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
          
          /*
        availableFunds = getWalletBalance()
        dispatchGroup.notify(queue: .main) {
            self.txrtlbl_AvailableFunds.text! = String(self.availableFunds)
        }*/
        
        
       
        //let docRef = db.collection("users").document(UID)
/*
        db.collection("users").whereField("uid", isEqualTo: UID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let firstName = document.get("firstname")
                        let wallet = document.data()["Wallet"] as? [String:Any] ?? ["":""]
                        let totalFunds = wallet["totalfunds"] as? Double ?? 0.0
                        print("firstName: ", firstName ?? "")
                        print("totalFunds: ", totalFunds)
                       
                    }
                }
        } */
                  
           /*
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID)") // Get documentID
                   // print("\(document.data)") // Get all data
                    print("\(document.data()["firstname"] as! String)") // Get specific data & type cast it.
                }
            }
        }
         */
        
      
    
         
    }
    
    func updateBalanceOnScreen() {
      //  print("Available Funds")
        self.txrtlbl_AvailableFunds.text = "Available Funds:      $ \(self.availableFunds)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // dispatchGroup.enter()
        /*
        availableFunds = getWalletBalance()
        */
        getWalletBalance()
        //semaphore.wait()
       // updateBalanceOnScreen()
        /*
        dispatchGroup.notify(queue: .main) {
            self.updateBalanceOnScreen()
        } */
        
    }
    
    func getWalletBalance () {
      
        let userDocRef = db.collection("users").document(UID)
        var totalFunds:Double = 0.0
        userDocRef.getDocument { document, error in
            if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
            }
            else {
              if let document = document {
                  //let id = document.documentID
                  let docData = document.data()
                  //let firstname = document.get("firstname")
                  let wallet = docData?["Wallet"] as? [String:Any] ?? ["":""]
                   totalFunds = wallet["totalfunds"] as? Double ?? 0
                  //print("firstName: ", firstname ?? "")
                  print("totalFunds: ", totalFunds)
                  self.availableFunds = totalFunds
                  self.updateBalanceOnScreen()
                 // self.dispatchGroup.leave()
                  //print("documentID: ", id)
                 
                  //self.txrtlbl_AvailableFunds.text! = String(totalFunds)
              
              }
            }
        
        }
        //dispatchGroup.wait()
       // semaphore.signal()
      
        
    }
    
    func addFundsToWallet(amount:Double) {
        let userDocRef = db.collection("users").document(UID)
       // let updatedFunds = availableFunds + amount
        
        userDocRef.updateData([
            "Wallet.totalfunds": amount
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    

    @IBAction func btn_AddMoneyClicked(_ sender: Any) {
       
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Add Money", message: "Please Enter Amount To Be Added in Wallet", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Please Enter Amount"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Add", style: .default) { [self] _ in

            // this code runs when the user hits the "save" button

            let addmoney = alertController.textFields![0].text
            
            
            let amount = Double (addmoney?.description ?? "0.0") ?? 0.0
            
            if amount > 0.0 {
                availableFunds = availableFunds + amount
                addFundsToWallet(amount: availableFunds)
                //self.txrtlbl_AvailableFunds.text = "Available Funds:      $ \(self.availableFunds)"
                updateBalanceOnScreen()
            }

            print(addmoney ?? "")
            
           

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func btn_WithdrawClicked(_ sender: Any) {
        
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Withdraw Money", message: "Please Enter Amount to be Withdrawn", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "Please Enter Amount"
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Withdraw", style: .default) { [self] _ in

            // this code runs when the user hits the "save" button

            let withdrawAmount = alertController.textFields![0].text
            
            
          let amount = Double (withdrawAmount?.description ?? "0.0") ?? 0.0
            
            if self.availableFunds > 0.0  && amount > 0.0 && self.availableFunds > amount{
                
                self.availableFunds = availableFunds - amount
                addFundsToWallet(amount: availableFunds)
             //   self.txrtlbl_AvailableFunds.text = "Available Funds:         $ \(self.availableFunds)"
                updateBalanceOnScreen()
            }

            print(withdrawAmount ?? "")
            
            

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true, completion: nil)
    }

}
