//
//  Validation.swift
//  Koinex
//
//  Created by Jasman Arora on 10/11/21.
//

import Foundation


struct Validation {
    
   static func isPasswordValid(password: String) -> Bool {
       // Minimum 8 Letter, 1 uppercase, 1 lowercase, 1 number, 1 special character
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPhone(phone: String) -> Bool {
               let phoneNumberRegex = "^[6-9]\\d{9}$"
               let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
               return phoneTest.evaluate(with: phone)
    }
    /*
    static func isValidName(name: String) -> Bool {
        // . matches a period rather than a range of characters
        //  \s matches whitespace (spaces and tabs)
        let nameRegEx = "^a-zA-Z"
        let namePred = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return namePred.evaluate(with: name)
    } */
    
  static func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
    }
    
    
}
