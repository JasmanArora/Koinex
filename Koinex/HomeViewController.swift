//
//  HomeViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 10/10/21.
//

import UIKit
import Alamofire
var UID = ""
class HomeViewController: UIViewController {
    
    @IBOutlet weak var lbl_btcPrice: UILabel!
    @IBOutlet weak var lbl_ethPrice: UILabel!
    @IBOutlet weak var lbl_adaPrice: UILabel!
    @IBOutlet weak var lbl_xrpPrice: UILabel!
    @IBOutlet weak var lbl_dogePrice: UILabel!
    
    
    
    let getCryptoPriceURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false"
    
    
    var cryptoDetails:[CoinModel]?
    var bitcoinPrice:Double = 0
    var ethereumPrice:Double = 0
    var cardonaPrice:Double = 0
    var ripplePrice:Double = 0
    var dogecoinPrice:Double = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
            self.fetchLatestPrice()
            })
        
       
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        
        //self.tabBarController?.navigationItem.hidesBackButton = true
        //self.tabBarController?.navigationItem.backButtonTitle = "Logout"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        timer.invalidate()
    }
    
    func fetchLatestPrice(){
        getCurrentCryptoPrices()
    }
    
    func getCurrentCryptoPrices() {
        
        AF.request(getCryptoPriceURL, method: .get, encoding:  JSONEncoding.default).responseJSON { [weak self] response in
            switch(response.result) {
            case.success(let data):
                print("Success")
               // print(data)
                if let dictionary = data as? [[String: Any]] {
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject:dictionary)
                    self?.cryptoDetails = try? JSONDecoder().decode([CoinModel].self, from: jsonData!)
                    
                    print(self?.cryptoDetails ?? "" )
                    
                    if !(self?.cryptoDetails?.isEmpty ?? false) {
                    for coins in self!.cryptoDetails! {
                        
                        switch coins.symbol {
                        case "btc":
                            self?.bitcoinPrice = coins.currentPrice
                            break
                        case "eth":
                            self?.ethereumPrice = coins.currentPrice
                            break
                        case "ada":
                            self?.cardonaPrice = coins.currentPrice
                            break
                        case "xrp":
                            self?.ripplePrice = coins.currentPrice
                            break
                        case "doge":
                            self?.dogecoinPrice = coins.currentPrice
                            break
                        default:
                            print(coins.id)
                           

                        }
                        
                        
                    }
                    }
                    
                    self?.displayCurrentCryptoPrices()
                }
                
                
            case.failure(let error):
                print("Not Success",error)
                
            }
        }
        
    }
    
    func displayCurrentCryptoPrices () {
        
        lbl_btcPrice.text = "$ " + String(bitcoinPrice)
        lbl_ethPrice.text = "$ " + String(ethereumPrice)
        lbl_adaPrice.text = "$ " + String(cardonaPrice)
        lbl_xrpPrice.text = "$ " + String(ripplePrice)
        lbl_dogePrice.text = "$ " + String(dogecoinPrice)
        print("Bitcoin Price: ", bitcoinPrice)
        print("Ethereum Price: ", ethereumPrice)
        print("Cardona Price: ", cardonaPrice)
        print("Ripple Price: ", ripplePrice)
        print("Dogecoin Price: ", dogecoinPrice)
        
        
    }
    
    
    
}

