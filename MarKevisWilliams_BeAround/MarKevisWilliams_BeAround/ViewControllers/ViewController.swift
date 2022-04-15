//
//  ViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/9/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FormatLook()
        PasswordTF.isSecureTextEntry = false
        PasswordTF.delegate = self
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        PasswordTF.isSecureTextEntry = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PasswordTF.resignFirstResponder()
        PasswordTF.isSecureTextEntry = true
        return false
    }
    
    
    
}

extension ViewController{
    func FormatLook(){
        let gradientlayer = CAGradientLayer()
        let primaryColor = UIColor(rgb: 0x5398c5 )
        let secondaryColor = UIColor(rgb: 0x977096)
        gradientlayer.frame = view.bounds
        gradientlayer.colors = [primaryColor.cgColor  ,secondaryColor.cgColor ]
        view.layer.insertSublayer(gradientlayer, at: 0)
        //fortmatting label
       
            
            
    }
    
   
}




