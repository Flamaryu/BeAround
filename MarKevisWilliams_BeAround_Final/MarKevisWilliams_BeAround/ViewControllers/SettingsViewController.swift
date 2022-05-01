//
//  SettingsViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseAuth


class SettingsViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var EmailTF: UITextField!
    
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    
    var email = ""
    var password = ""
    var emailChange = false
    var passWordChange = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        EmailTF.text = Auth.auth().currentUser?.email
        ErrorLabel.alpha = 0
        SaveButton.alpha = 0
        CancelButton.alpha = 0
        emailChange = false
        passWordChange = false
        // Do any additional setup after loading the view.
    }
    
    @IBAction func EmailEditTapped(_ sender: UIButton) {
        EmailTF.isEnabled = true
        EmailTF.becomeFirstResponder()
    }
    
    @IBAction func passWordEditTapped(_ sender: UIButton) {
        PasswordTF.isEnabled = true
        PasswordTF.becomeFirstResponder()
    }
    
    func showError(_ error: String){
        ErrorLabel.text = error
        ErrorLabel.alpha = 1
    }
    
    @IBAction func SaveTapped(_ sender: UIButton) {
        
        if emailChange ==  true{
            let cleanEmail = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().currentUser?.updateEmail(to: cleanEmail, completion: { error in
                if error != nil{
                    let user = Auth.auth().currentUser
                    var credential: AuthCredential
                    
                    //prompting user for info
                    
                    let reEnterInfo = UIAlertController(title: "Re-Enter Email and Password", message:"", preferredStyle: .alert)
                    reEnterInfo.addTextField { (textField) in
                        textField.placeholder = "Enter Email"
                        
                    }
                    
                    reEnterInfo.addTextField { (textField) in
                        textField.placeholder = "Enter Password"
                        textField.isSecureTextEntry = true
                    }
                    let SignIn = UIAlertAction(title: "SignIn", style: .default) { [weak reEnterInfo] (_) in // binding textField
                        self.email = (reEnterInfo?.textFields![0].text)!
                        self.password = (reEnterInfo?.textFields![1].text)!
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    reEnterInfo.addAction(SignIn)
                    reEnterInfo.addAction(cancel)
                    
                    self.present(reEnterInfo, animated: true, completion: nil)
                    
                    //using the info to resign in
                    credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)
                    
                    user?.reauthenticate(with: credential) { result, error in
                        if let error = error {
                            self.showError(error.localizedDescription)
                        } else {
                            // User re-authenticated.
                            Auth.auth().currentUser?.updateEmail(to: self.EmailTF.text!, completion: { error in
                                if error != nil{
                                    return
                                }
                            })
                        }
                    }
                    
                }
            })
        }
        if passWordChange == true{
            let cleanPassword = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().currentUser?.updatePassword(to: cleanPassword, completion: { error in
                if error != nil{
                    let user = Auth.auth().currentUser
                    var credential: AuthCredential
                    
                    //prompting user for info
                    
                    let reEnterInfo = UIAlertController(title: "Re-Enter Email and Password", message:"", preferredStyle: .alert)
                    reEnterInfo.addTextField { (textField) in
                        textField.placeholder = "Enter Email"
                        
                    }
                    
                    reEnterInfo.addTextField { (textField) in
                        textField.placeholder = "Enter Password"
                        textField.isSecureTextEntry = true
                    }
                    let SignIn = UIAlertAction(title: "SignIn", style: .default) { [weak reEnterInfo] (_) in // binding textField
                        self.email = (reEnterInfo?.textFields![0].text)!
                        self.password = (reEnterInfo?.textFields![1].text)!
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    reEnterInfo.addAction(SignIn)
                    reEnterInfo.addAction(cancel)
                    
                    self.present(reEnterInfo, animated: true, completion: nil)
                    
                    //using the info to resign in
                    credential = EmailAuthProvider.credential(withEmail: self.email, password: self.password)
                    
                    user?.reauthenticate(with: credential) { result, error in
                        if let error = error {
                            self.showError(error.localizedDescription)
                        } else {
                            // User re-authenticated.
                            Auth.auth().currentUser?.updateEmail(to: self.EmailTF.text!, completion: { error in
                                if error != nil{
                                    return
                                }
                            })
                        }
                    }
                    
                }
            })
           
        }
        ErrorLabel.alpha = 0
        SaveButton.isEnabled = false
        SaveButton.alpha = 0
        CancelButton.alpha = 0
        CancelButton.isEnabled = false
        passWordChange = false
        emailChange =  false
    }
    
    
    @IBAction func CancelTapped(_ sender: UIButton) {
        EmailTF.text = Auth.auth().currentUser?.email
        PasswordTF.text = "password"
        SaveButton.isEnabled = false
        SaveButton.alpha = 0
        CancelButton.alpha = 0
        CancelButton.isEnabled = false
        
    }
    
    
    func Validation(_ textField: UITextField) -> String?{
        if textField == EmailTF{
            if EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Can't Leave anything blank!"
            }
            let cleanEmail = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Utilities.isValidEmail(cleanEmail) == false{
                return "Email is not valid!"
            }
        }
        else{
            if PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                return "Can't Leave anything blank!"
            }
            let cleanPWD = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Utilities.isPasswordValid(cleanPWD) == false{
                return "Password ust contain at least 1 uppercase letter, 1 lowwercase letter, 1 number and one special character "
            }
        }
        return nil
    }
    
    
    
    
    @IBAction func SignOutTapped(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginVC")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == EmailTF{
            emailChange = true
           
        }
        else if textField == PasswordTF{
            passWordChange = true
        }
        if let  error = Validation(textField){
            showError(error)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.isEnabled = false
        SaveButton.alpha = 1
        SaveButton.isEnabled = true
        CancelButton.isEnabled = true
        CancelButton.alpha = 1
        
        
        
        
        return false
    }
    
}
