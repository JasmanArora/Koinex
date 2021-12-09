//
//  PortfolioViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 11/21/21.
//

import UIKit
import FirebaseFirestore

class PortfolioViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var lbl_btcQty: UILabel!
    @IBOutlet weak var lbl_btcPrice: UILabel!
    @IBOutlet weak var lbl_ethQty: UILabel!
    @IBOutlet weak var lbl_ethPrice: UILabel!
    @IBOutlet weak var lbl_adaQty: UILabel!
    @IBOutlet weak var lbl_adaPrice: UILabel!
    @IBOutlet weak var lbl_xrpQty: UILabel!
    @IBOutlet weak var lbl_xrpPrice: UILabel!
    @IBOutlet weak var lbl_dogeQty: UILabel!
    @IBOutlet weak var lbl_dogePrice: UILabel!
    @IBOutlet weak var lbl_totalHoldings: UILabel!
    
    var userPortfolio : [String:Double] = ["BTC" : 0.0, "ETH":0.0, "ADA": 0.0, "XRP": 0.0, "DOGE": 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        getUserPortfolio()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.updatePrices()
        }
        
    }
    func updatePrices() {
        let btcPrice = userPortfolio["BTC"]! * globalPrices["BTC"]!
        let ethPrice = userPortfolio["ETH"]! * globalPrices["ETH"]!
        let adaPrice = userPortfolio["ADA"]! * globalPrices["ADA"]!
        let xrpPrice = userPortfolio["XRP"]! * globalPrices["XRP"]!
        let dogePrice = userPortfolio["DOGE"]! * globalPrices["DOGE"]!
        lbl_btcQty.text = "My Holdings: " + String(userPortfolio["BTC"]!)
        lbl_btcPrice.text = "Total Price: $ " + String(btcPrice)
        lbl_ethQty.text = "My Holdings: " + String(userPortfolio["ETH"]!)
        lbl_ethPrice.text = "Total Price: $ " + String(ethPrice)
        lbl_adaQty.text = "My Holdings: " + String(userPortfolio["ADA"]!)
        lbl_adaPrice.text = "Total Price: $ " + String(adaPrice)
        lbl_xrpQty.text = "My Holdings: " + String(userPortfolio["XRP"]!)
        lbl_xrpPrice.text = "Total Price: $ " + String(xrpPrice)
        lbl_dogeQty.text = "My Holdings: " + String(userPortfolio["DOGE"]!)
        lbl_dogePrice.text = "Total Price: $ " + String(dogePrice)
        let totalHoldings = btcPrice + ethPrice + adaPrice + xrpPrice + dogePrice
        lbl_totalHoldings.text = "$ \(totalHoldings)"
       
     
        
    }
    func getUserPortfolio() {
        let userDocRef = db.collection("users").document(UID)
      
        userDocRef.getDocument { document, error in
            if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
            }
            else {
              if let document = document {
             
                  let docData = document.data()
              
                  let portfolio = docData?["Portfolio"] as? [String:Any] ?? ["":""]
                  self.userPortfolio["BTC"] = portfolio["BTC"] as? Double ?? 0
                  self.userPortfolio["ETH"] = portfolio["ETH"] as? Double ?? 0
                  self.userPortfolio["ADA"] = portfolio["ADA"] as? Double ?? 0
                  self.userPortfolio["XRP"] = portfolio["XRP"] as? Double ?? 0
                  self.userPortfolio["DOGE"] = portfolio["DOGE"] as? Double ?? 0
                  
               
              }
            }
        
        }
    }
   

}
