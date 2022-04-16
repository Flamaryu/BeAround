//
//  SettingsViewController.swift
//  MarKevisWilliams_BeAround
//
//  Created by markevis williams on 4/13/22.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.FormatLook(self)
        // Do any additional setup after loading the view.
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
    
}
