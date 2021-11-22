//
//  BuySellViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 11/21/21.
//

import UIKit

class BuySellViewController: UIViewController {

    @IBOutlet weak var txtField_name: UITextField!
    @IBOutlet weak var txtField_buySell: UITextField!
    @IBOutlet weak var txtField_qty: UITextField!
    var selectedCoin: String?
    var coinsList = ["Bitcoin (BTC)", "Ethereum (ETH)", "Cardona (ADA)", "Ripple (XRP)", "Dogecoin (DOGE"]
    var buysellList = ["BUY", "SELL"]
    var selectedBuySell: String?
    var activeTextField = UITextField()
    var price:Double = 10000
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView(textField: txtField_name)
        dismissPickerView(textField: txtField_name)
        createPickerView(textField: txtField_buySell)
        dismissPickerView(textField: txtField_buySell)
        txtField_qty.delegate = self
        textFieldDidEndEditing(txtField_qty)
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let qty:String = txtField_qty.text ?? "0"
        let qtyAmount:Double = Double(qty) ?? 0.0
        let finalPrice = qtyAmount*price
        print("Final price is ", finalPrice)
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
