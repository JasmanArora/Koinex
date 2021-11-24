//
//  BuySellViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 11/21/21.
//

import UIKit
import FirebaseFirestore
class BuySellViewController: UIViewController {
  
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var txtField_name: UITextField!
    @IBOutlet weak var txtField_buySell: UITextField!
    @IBOutlet weak var txtField_qty: UITextField!
    let db = Firestore.firestore()
    var selectedCoin: String?
    var coinsList = ["Bitcoin (BTC)", "Ethereum (ETH)", "Cardona (ADA)", "Ripple (XRP)", "Dogecoin (DOGE)"]
    var userPortfolio : [String:Double] = ["BTC" : 0.0, "ETH":0.0, "ADA": 0.0, "XRP": 0.0, "DOGE": 0.0]
    var buysellList = ["BUY", "SELL"]
    var selectedBuySell: String?
    var activeTextField = UITextField()
    var price:Double = 0
    var quantity:Double = 0
    var prices:[String:Double]?
    var userAvailableFunds:Double = 0.0
    var userCashback:Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        getWalletBalance()
        getUserPortfolio()
        createPickerView(textField: txtField_name)
        dismissPickerView(textField: txtField_name)
        createPickerView(textField: txtField_buySell)
        dismissPickerView(textField: txtField_buySell)
        txtField_qty.delegate = self
        textFieldDidEndEditing(txtField_qty)
        txtField_buySell.text = selectedBuySell
        txtField_name.text = selectedCoin
        lbl_price.text = String(price)
        // Do any additional setup after loading the view.
    }
    @IBAction func btn_cancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_confirmClicked(_ sender: Any) {
        if (quantity > 0) {
            if (selectedBuySell == "BUY") {
                // BUY
                if (userAvailableFunds >= price) {
                    updateUserBuyPortfolio()
                } else {
                    print("Please Add Sufficicent Funds to Wallet")
                }
            } else {
                // SELL
                let coinSymbol = getCoinSymbol(name: selectedCoin ?? "")
                if userPortfolio[coinSymbol]! >= quantity {
                    updateUserSellPortfolio()
                } else {
                    print("You dont have enough \(selectedCoin ?? "") to Sell")
                }
            }
        } else {
            print("Please Select A Valid Quantity")
        }
    }
    
    func getCoinSymbol(name:String) -> String {
     //   var coinsList = ["Bitcoin (BTC)", "Ethereum (ETH)", "Cardona (ADA)", "Ripple (XRP)", "Dogecoin (DOGE)"]
        switch name {
        case "Bitcoin (BTC)":
            return "BTC"
        case "Ethereum (ETH)":
            return "ETH"
        case "Cardona (ADA)":
            return "ADA"
        case "Ripple (XRP)":
            return "XRP"
        case "Dogecoin (DOGE)":
            return "DOGE"
        default:
            return ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let qty:String = txtField_qty.text ?? "0"
        let qtyAmount:Double = Double(qty) ?? 0.0
        let finalPrice = qtyAmount*price
        lbl_price.text = String(finalPrice)
        print("Final price is ", finalPrice)
        quantity = qtyAmount
    }
    
    func createPickerView(textField: UITextField) {
           let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.systemBrown
        pickerView.setValue(UIColor.white, forKeyPath: "textColor")
        pickerView.delegate = self
         textField.inputView = pickerView
        
    }
    func dismissPickerView(textField: UITextField) {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    func updateUserBuyPortfolio() {
        let printedPrice:String = lbl_price.text ?? "0"
        price = Double(printedPrice) ?? 0
        let coinSymbol:String = getCoinSymbol(name: selectedCoin ?? "")
        let portfolioKey = "Portfolio." + coinSymbol
        let portfolioAmount:Double = userPortfolio[coinSymbol]! + quantity
        print("Portfolio Key: ", portfolioKey)
        print("Portfolio Amount: ", portfolioAmount)
        let amountToUpdate = userAvailableFunds - price
        let userDocRef = db.collection("users").document(UID)
       
        
        userDocRef.updateData([
            "Wallet.totalfunds": amountToUpdate,
            "Wallet.cashback": userCashback + price/50,
            portfolioKey: portfolioAmount
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                print("Transaction Succesful")
                self.updateUserTransaction()
                self.showSucessAlert()
            }
        }
    }
    
    func updateUserSellPortfolio() {
        let printedPrice:String = lbl_price.text ?? "0"
        price = Double(printedPrice) ?? 0
        let coinSymbol:String = getCoinSymbol(name: selectedCoin ?? "")
        let portfolioKey = "Portfolio." + coinSymbol
        let portfolioAmount:Double = userPortfolio[coinSymbol]! - quantity
        let amountToUpdate = userAvailableFunds + price
        let userDocRef = db.collection("users").document(UID)
       
        
        userDocRef.updateData([
            "Wallet.totalfunds": amountToUpdate,
            portfolioKey: portfolioAmount
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                print("Transaction Succesful")
                self.updateUserTransaction()
                self.showSucessAlert()
            }
        }
    }
    
    
    func updateUserTransaction() {
        let date = Date()
        let coinSymbol = getCoinSymbol(name: selectedCoin ?? "")
        self.db.collection("transactions").document().setData(["coiname": selectedCoin!, "datetime":date, "marketvalue":prices![coinSymbol]!, "quantity": quantity, "totalprice": price, "transactiontype": selectedBuySell! ,"uid": UID]) { (err) in
        
            
            if err != nil {
                print("Error Assigning Info About Transaction")
                //Alert.showBasicAlert(vc: self, title: "Error!", msg: "Oops Some Unexpected Error Occured, please try after some time!")
            }
            
            
        }
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
    
    func getWalletBalance () {
      
        let userDocRef = db.collection("users").document(UID)
        var totalFunds:Double = 0.0
        userDocRef.getDocument { document, error in
            if let error = error as NSError? {
            print("Error getting document: \(error.localizedDescription)")
            }
            else {
              if let document = document {
             
                  let docData = document.data()
              
                  let wallet = docData?["Wallet"] as? [String:Any] ?? ["":""]
                   totalFunds = wallet["totalfunds"] as? Double ?? 0
                  self.userCashback = wallet["cashback"] as? Double ?? 0
                  print("totalFunds: ", totalFunds)
                  self.userAvailableFunds = totalFunds
               
              }
            }
        
        }
       
      
        
    }

    func showSucessAlert() {
        
        let loginAlert = UIAlertController(title: "Success!", message: "Transaction Succesful.", preferredStyle: UIAlertController.Style.alert)

        loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              //print("Handle Ok logic here")
              self.dismiss(animated: true, completion: nil)
        }))

        present(loginAlert, animated: true, completion: nil)
    }
    

}


extension BuySellViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtField_name.isFirstResponder{
            
            return coinsList.count
        } else if txtField_buySell.isFirstResponder{

            return buysellList.count
        }
        return 0
    // number of dropdown items
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtField_name.isFirstResponder{
            
            return coinsList[row]
        } else if txtField_buySell.isFirstResponder{

            return buysellList[row]
        }
        return nil
  
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if txtField_name.isFirstResponder{
            selectedCoin = coinsList[row] // selected item
            txtField_name.text = selectedCoin
            let coinSymbol = getCoinSymbol(name: selectedCoin ?? "Bitcoin (BTC)")
            price = prices?[coinSymbol] ?? 0.0
        } else if txtField_buySell.isFirstResponder{

            selectedBuySell = buysellList[row] // selected item
            txtField_buySell.text = selectedBuySell
        }
   
    }
    /*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: coinsList[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    } */
    
}
