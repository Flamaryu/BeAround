//
//  Utility.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/15/22.
//

import Foundation
import UIKit

class Utilities{
static func styleTextField(_ textfield:UITextField) {
    
    // Create the bottom line
    let bottomLine = CALayer()
    
    bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
    
    bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
    
    // Remove border on text field
    textfield.borderStyle = .none
    
    // Add the line to the text field
    textfield.layer.addSublayer(bottomLine)
    
}

static func styleFilledButton(_ button:UIButton) {
    
    // Filled rounded corner style
    button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.white
}

static func styleHollowButton(_ button:UIButton) {
    
    // Hollow rounded corner style
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.cornerRadius = 25.0
    button.tintColor = UIColor.black
}
static func FormatLook(_ VC: UIViewController){
    //sets the background to the gradient color I want
    let gradientlayer = CAGradientLayer()
    let primaryColor = UIColor(rgb: 0x5398c5 )
    let secondaryColor = UIColor(rgb: 0x977096)
    gradientlayer.frame = VC.view.bounds
    gradientlayer.colors = [primaryColor.cgColor  ,secondaryColor.cgColor ]
    VC.view.layer.insertSublayer(gradientlayer, at: 0)
}
static func isPasswordValid(_ password : String) -> Bool {
    
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}

static func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}

static func isPasswordSame(password: String , confirmPassword : String) -> Bool {
     if password == confirmPassword{
       return true
     }
    else{
       return false
     }
 }


}

