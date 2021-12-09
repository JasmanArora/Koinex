//
//  RewardsViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 11/21/21.
//

import UIKit
import FirebaseFirestore

class RewardsViewController: UIViewController {
let db = Firestore.firestore()
    @IBOutlet weak var lbl_userCashback: UILabel!
    var userCashback:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        getUserCashback()
        
    }
    
    func getUserCashback () {
      
        let userDocRef = db.collection("users").document(UID)
        userDocRef.getDocument { document, error in
            if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
            }
            else {
              if let document = document {
                
                  let docData = document.data()
                  
                  let wallet = docData?["Wallet"] as? [String:Any] ?? ["":""]
                  self.userCashback = wallet["cashback"] as? Double ?? 0
                  let roundedValue = round(self.userCashback * 1000) / 1000.0
                  self.lbl_userCashback.text = "Total Cashback:      $ \(roundedValue)"
              
              }
            }
        
        }
      
      
        
    }
    //Total Cashback:      $ 0.0    
}
