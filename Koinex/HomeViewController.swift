//
//  HomeViewController.swift
//  Koinex
//
//  Created by Jasman Arora on 10/10/21.
//

import UIKit
import Alamofire
var UID = ""
var globalPrices: [String:Double] = ["BTC" : 0.0, "ETH":0.0, "ADA": 0.0, "XRP": 0.0, "DOGE": 0.0]
class HomeViewController: UIViewController {
    
    @IBOutlet weak var lbl_btcPrice: UILabel!
    @IBOutlet weak var lbl_ethPrice: UILabel!
    @IBOutlet weak var lbl_adaPrice: UILabel!
    @IBOutlet weak var lbl_xrpPrice: UILabel!
    @IBOutlet weak var lbl_dogePrice: UILabel!
    
    @IBOutlet weak var lbl_btcchange: UILabel!
    @IBOutlet weak var lbl_btclow: UILabel!
    @IBOutlet weak var lbl_btchigh: UILabel!
    @IBOutlet weak var img_btc: UIImageView!
    
    @IBOutlet weak var lbl_ethchange: UILabel!
    @IBOutlet weak var lbl_ethlow: UILabel!
    @IBOutlet weak var lbl_ethhigh: UILabel!
    @IBOutlet weak var img_eth: UIImageView!
    
    @IBOutlet weak var lbl_adachange: UILabel!
    @IBOutlet weak var lbl_adalow: UILabel!
    @IBOutlet weak var lbl_adahigh: UILabel!
    @IBOutlet weak var img_ada: UIImageView!
    
    @IBOutlet weak var lbl_xrpchange: UILabel!
    @IBOutlet weak var lbl_xrplow: UILabel!
    @IBOutlet weak var lbl_xrphigh: UILabel!
    @IBOutlet weak var img_xrp: UIImageView!
    
    @IBOutlet weak var lbl_dogechange: UILabel!
    @IBOutlet weak var lbl_dogelow: UILabel!
    @IBOutlet weak var lbl_dogehigh: UILabel!
    @IBOutlet weak var img_doge: UIImageView!
    
    
    
    let getCryptoPriceURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false"
    
    
    var cryptoDetails:[CoinModel]?
  //  var bitcoinPrice:Double = 0
  //  var ethereumPrice:Double = 0
  //  var cardonaPrice:Double = 0
   // var ripplePrice:Double = 0
   // var dogecoinPrice:Double = 0
    
    var prices: [String:Double] = ["BTC" : 0.0, "ETH":0.0, "ADA": 0.0, "XRP": 0.0, "DOGE": 0.0]

    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(prices)
        //prices["BTC"] = 123
        //print(prices)
        
        
//        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { _ in
//            self.fetchLatestPrice()
//            })
//
       getCurrentCryptoPrices()
       
    }
    
    @IBAction func btn_BuyClick(_ sender: Any) {
        let buySellVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuySellViewController") as! BuySellViewController
        
      //  Bitcoin (BTC)", "Ethereum (ETH)", "Cardona (ADA)", "Ripple (XRP)", "Dogecoin (DOGE)"
        switch (sender as AnyObject).tag {
        case 0:
            buySellVC.selectedCoin = "Bitcoin (BTC)"
            buySellVC.price = prices["BTC"] ?? 0
            break
        case 1:
            buySellVC.selectedCoin = "Ethereum (ETH)"
            buySellVC.price = prices["ETH"] ?? 0
            break
        case 2:
            buySellVC.selectedCoin = "Cardona (ADA)"
            buySellVC.price = prices["ADA"] ?? 0
            break
        case 3:
            buySellVC.selectedCoin = "Ripple (XRP)"
            buySellVC.price = prices["XRP"] ?? 0
            break
        case 4:
            buySellVC.selectedCoin = "Dogecoin (DOGE)"
            buySellVC.price = prices["DOGE"] ?? 0
            break
        default:
        break
        }
        buySellVC.prices = prices
        buySellVC.selectedBuySell = "BUY"
        buySellVC.modalPresentationStyle = .popover
        buySellVC.modalTransitionStyle = .coverVertical
        self.present(buySellVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_SellClick(_ sender: Any) {
        let buySellVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuySellViewController") as! BuySellViewController
        
      //  Bitcoin (BTC)", "Ethereum (ETH)", "Cardona (ADA)", "Ripple (XRP)", "Dogecoin (DOGE)"
        switch (sender as AnyObject).tag {
        case 0:
            buySellVC.selectedCoin = "Bitcoin (BTC)"
            buySellVC.price = prices["BTC"] ?? 0
            break
        case 1:
            buySellVC.selectedCoin = "Ethereum (ETH)"
            buySellVC.price = prices["ETH"] ?? 0
            break
        case 2:
            buySellVC.selectedCoin = "Cardona (ADA)"
            buySellVC.price = prices["ADA"] ?? 0
            break
        case 3:
            buySellVC.selectedCoin = "Ripple (XRP)"
            buySellVC.price = prices["XRP"] ?? 0
            break
        case 4:
            buySellVC.selectedCoin = "Dogecoin (DOGE)"
            buySellVC.price = prices["DOGE"] ?? 0
            break
        default:
        break
        }
        buySellVC.prices = prices
        buySellVC.selectedBuySell = "SELL"
        buySellVC.modalPresentationStyle = .popover
        buySellVC.modalTransitionStyle = .coverVertical
        self.present(buySellVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
        
        //self.tabBarController?.navigationItem.hidesBackButton = true
        //self.tabBarController?.navigationItem.backButtonTitle = "Logout"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

     
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
                            self?.prices["BTC"] = coins.currentPrice
                            self?.lbl_btclow.text = "$ \(coins.low24H ?? 0.0)"
                            self?.lbl_btchigh.text = "$ \(coins.high24H ?? 0.0)"
                            self?.lbl_btcchange.text = "\(coins.priceChangePercentage24H ?? 0.0) %"
//                            let url = URL(string: coins.image)
//                            let data = try? Data(contentsOf: url!)
//                            self?.img_btc.image = UIImage(data: data!)
                            break
                        case "eth":
                            self?.prices["ETH"] = coins.currentPrice
                            self?.lbl_ethlow.text = "$ \(coins.low24H ?? 0.0)"
                            self?.lbl_ethhigh.text = "$ \(coins.high24H ?? 0.0)"
                            self?.lbl_ethchange.text = "\(coins.priceChangePercentage24H ?? 0.0) %"
//                            let url = URL(string: coins.image)
//                            let data = try? Data(contentsOf: url!)
//                            self?.img_eth.image = UIImage(data: data!)
                            break
                        case "ada":
                            self?.prices["ADA"] = coins.currentPrice
                            self?.lbl_adalow.text = "$ \(coins.low24H ?? 0.0)"
                            self?.lbl_adahigh.text = "$ \(coins.high24H ?? 0.0)"
                            self?.lbl_adachange.text = "\(coins.priceChangePercentage24H ?? 0.0) %"
//                            let url = URL(string: coins.image)
//                            let data = try? Data(contentsOf: url!)
//                            self?.img_ada.image = UIImage(data: data!)
                            break
                        case "xrp":
                            self?.prices["XRP"] = coins.currentPrice
                            self?.lbl_xrplow.text = "$ \(coins.low24H ?? 0.0)"
                            self?.lbl_xrphigh.text = "$ \(coins.high24H ?? 0.0)"
                            self?.lbl_xrpchange.text = "\(coins.priceChangePercentage24H ?? 0.0) %"
//                            let url = URL(string: coins.image)
//                            let data = try? Data(contentsOf: url!)
//                            self?.img_xrp.image = UIImage(data: data!)
                            break
                        case "doge":
                            self?.prices["DOGE"] = coins.currentPrice
                            self?.lbl_dogelow.text = "$ \(coins.low24H ?? 0.0)"
                            self?.lbl_dogehigh.text = "$ \(coins.high24H ?? 0.0)"
                            self?.lbl_dogechange.text = "\(coins.priceChangePercentage24H ?? 0.0) %"
//                            let url = URL(string: coins.image)
//                            let data = try? Data(contentsOf: url!)
//                            self?.img_doge.image = UIImage(data: data!)
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
        
        lbl_btcPrice.text = "Bitcoin (BTC): $ " + String(prices["BTC"] ?? 0.0)
        lbl_ethPrice.text = "Ethereum (ETH): $ " + String(prices["ETH"] ?? 0.0)
        lbl_adaPrice.text = "Cardona (ADA): $ " + String(prices["ADA"] ?? 0.0)
        lbl_xrpPrice.text = "Ripple (XRP): $ " + String(prices["XRP"] ?? 0.0)
        lbl_dogePrice.text = "Dogecoin (DOGE): $ " + String(prices["DOGE"] ?? 0.0)
        print("Bitcoin Price: ", prices["BTC"] ?? 0.0)
        print("Ethereum Price: ", prices["ETH"] ?? 0.0)
        print("Cardona Price: ", prices["ADA"] ?? 0.0)
        print("Ripple Price: ", prices["XRP"] ?? 0.0)
        print("Dogecoin Price: ", prices["DOGE"] ?? 0.0)
        globalPrices = prices
        
        
    }
    
    
    
}

