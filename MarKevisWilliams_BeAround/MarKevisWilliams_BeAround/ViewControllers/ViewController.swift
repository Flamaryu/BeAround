//
//  ViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/9/22.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ErrorLabel.alpha = 0
        PasswordTF.isSecureTextEntry = false
        PasswordTF.delegate = self
        Utilities.FormatLook(self)
        
       
    }
    
    func Validatetion() -> String?{
        if PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ error: String){
        ErrorLabel.text = error
        ErrorLabel.alpha = 1
    }
    
    @IBAction func LoginTapped(_ sender: UIButton) {
        let error = Validatetion()
        if error != nil{
            showError(error!)
        }
        else{
            let email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil{
                    self.showError(error!.localizedDescription)
                }
                else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                      let mainTabBarController = storyboard.instantiateViewController(identifier: "TabbedVC")
                      
                      // This is to get the SceneDelegate object from your view controller
                      // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

                }
            }
        }
        
    }
    
    
    
    

}

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == PasswordTF{
            PasswordTF.isSecureTextEntry = false
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == PasswordTF && !PasswordTF.isSecureTextEntry{
            PasswordTF.isSecureTextEntry = true
        }
        return true
    }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        PasswordTF.resignFirstResponder()
        return false
    }
    
}




