//
//  Utility.swift
//  Koinex
//
//  Created by Jasman Arora on 10/11/21.
//

import Foundation
import UIKit

struct Alert {
    
   static func showBasicAlert(vc: UIViewController, title: String, msg: String) {
        
        let loginAlert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        loginAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Basic Alert Ok Clicked")
        }))

        vc.present(loginAlert, animated: true, completion: nil)
    }
 
}
